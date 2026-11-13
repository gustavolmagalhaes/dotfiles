{ lib, config, pkgs, configDir, secrets, ...}:
let
  secrets_file = config.age.secrets.baikal_password.path;

  readSecretVar = var: [
      "sh"
      "-c"
      "source ${secrets_file} && echo \$${var}"
    ];
in lib.my.mkModule { inherit config; } "apps.utils.khal" "KHAL" {
  hm.programs = {
    khal = {
      enable = true;
      locale = {
        timeformat = "%H:%M";
        dateformat = "%Y-%m-%d";
        longdateformat = "%Y-%m-%d";
        datetimeformat = "%Y-%m-%d %H:%M";
        longdatetimeformat = "%Y-%m-%d %H:%M";
      };
      settings = {
        default = {
          default_calendar = "default";
          highligh_event_days = true;
        };
      };
    };
    vdirsyncer = {
      enable = true;
    };
  };

  hm.services.vdirsyncer = {
    enable = true;
    frequency = "*:0/15";
  };

  # age.secrets.baikal_password.file = secrets.baikal_password;


  # TODO: remove this from here
  hm.accounts.calendar = {
    basePath = "${config.my.configHome}/calendars";
    accounts = {
      baikal = {
        primary = true;
        primaryCollection = "personal";
        local = {
          type = "filesystem";
          fileExt = ".ics";
        };
        remote = {
          type = "caldav";
          url = "https://baikal.viper.lan/dav.php/";
          userName = "gustavo";
          passwordCommand = readSecretVar "PASSWORD";
        };
        vdirsyncer = {
          enable = true;
          collections = ["from a" "from b"];
          conflictResolution = "remote wins";
        };
        khal = {
          enable = true;
          type = "discover";
        };
      };
    };
  };

  hm.home.packages = [
    (pkgs.writeShellScriptBin "khal-notify" ''
      NOTIFIED_FILE="/tmp/khal_notified_events"
      touch "$NOTIFIED_FILE"

      # Use full path to khal if possible, or assume it's in PATH from home-manager
      export PATH="$PATH:${pkgs.khal}/bin:${pkgs.coreutils}/bin:${pkgs.gnugrep}/bin:${pkgs.libnotify}/bin"

      events=$(khal list now 15m --notstarted --format "{start-time}|{title}" 2>/dev/null)

      if [[ -n "$events" && "$events" != *"No events"* ]]; then
          while IFS= read -r line; do
              if [[ ! "$line" =~ \| ]]; then continue; fi
              time="''${line%%|*}"
              title="''${line#*|}"
              if [[ -z "$time" ]]; then continue; fi

              event_hash=$(echo "$time$title" | md5sum | cut -d' ' -f1)
              if ! grep -q "$event_hash" "$NOTIFIED_FILE"; then
                  notify-send -u critical -i x-office-calendar "Upcoming Event" "$title at $time"
                  echo "$event_hash" >> "$NOTIFIED_FILE"
              fi
          done <<< "$events"
      fi
    '')
  ];

  hm.systemd.user.timers."khal-notify" = {
    Unit.Description = "Timer for khal calendar notifications";
    Timer.OnBootSec = "5m";
    Timer.OnUnitActiveSec = "5m";
    Install.WantedBy = ["timers.target"];
  };

  hm.systemd.user.services."khal-notify" = {
    Unit.Description = "Khal calendar notifications";
    Service.ExecStart = "${pkgs.bash}/bin/bash -c 'khal-notify'";
  };
}
