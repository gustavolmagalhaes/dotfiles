{ lib, pkgs, config, ... }:
let
  inherit (lib)
    flatten
    isAttrs
    isList
    mapAttrsToList
    removeAttrs
    ;

  format = pkgs.my.kdl { version = 1; };
  inherit (format.lib) node;

  toNode =
    name: value:
    let
      type = value._type or null;
      arguments = value._args or [ ];
      properties = value._props or { };
      children = flatten (
        mapAttrsToList toNode (
          removeAttrs value [
            "_type"
            "_args"
            "_props"
          ]
        )
      );
    in
    if isAttrs value then
      (node name type arguments properties children)
    else if isList value then
      map (toNode name) value
    else
      (node name null [ value ] { } [ ]);

  mkProps = props: { _props = props; };
  mkArgs = args: { _args = args; };
  mkSpawn = args: { spawn = mkArgs args; };
  mkSpawnLocked = args: (mkSpawn args) // (mkProps { allow-when-locked = true; });

  generate = settings: format.generate "config.kdl" (flatten (mapAttrsToList toNode settings));

  niri_config = {
    input = {
      keyboard = {
        xkb = {
          layout = "pt";
          variant = ""; # mayber pt-latin1
        };
      };
      touchpad = {
        tap = { };
        natural-scroll = { };
      };
      warp-mouse-to-focus = { };
      focus-follows-mouse = mkProps { max-scroll-amount = "0%"; };
      # allow using the power key as a mic mute button
      disable-power-key-handling = { };

      mod-key = "Alt";

    };

    cursor = {
      xcursor-theme = "Adwaita";
    };

    # Disable client-side decorations
    prefer-no-csd = { };

    layout = {
      gaps = 4;

      preset-column-widths = {
        proportion = [
          0.33333
          0.5
          0.66667
        ];
      };

      default-column-width = {
        proportion = 0.5;
      };

      focus-ring = {
        width = 2;

        active-color = lib.my.colors.lightblue;
        inactive-color = lib.my.colors.lightgrey;
      };

      # Disable border since we're using focus ring instead
      border = {
        off = { };
      };

      tab-indicator = {
        hide-when-single-tab = { };
        # avoid overlapping the indicator with windows
        place-within-column = { };
      };
    };

    output = map (
      monitor:
      {
        _args = [ monitor.name ];
      }
      // (lib.optionalAttrs (monitor.position != null) {
        position = mkProps { inherit (monitor.position) x y; };
      })
      // (lib.optionalAttrs monitor.primary {
        focus-at-startup = { };
      })
    ) config.my.config.graphical.monitors;

    # Disable saving screenshots to disk
    screenshot-path = null;

    binds = {
      # Show available hotkeys (equals to Mod + ?)
      "Mod+Shift+Slash" = {
        show-hotkey-overlay = { };
      };

      # Spawn programs
      "Mod+T" = mkSpawn [
        "ghostty"
        "+new-window"
      ];
      "Mod+D" = {
        spawn = "fuzzel";
      };
      "Mod+ccedilla" = {
        spawn = "swaylock";
      };

      # Window actions
      "Mod+Q" = {
        close-window = { };
      };
      "Mod+R" = {
        switch-preset-column-width = { };
      };
      "Mod+Shift+R" = {
        reset-window-height = { };
      };
      "Mod+F" = {
        maximize-column = { };
      };
      "Mod+Shift+F" = {
        fullscreen-window = { };
      };
      "Mod+Ctrl+F" = {
        maximize-window-to-edges = { };
      };
      "Mod+Ctrl+Shift+F" = {
        toggle-windowed-fullscreen = { };
      };
      "Mod+X" = {
        center-column = { };
      };

      # Focus/move columns/windows
      "Mod+H" = {
        focus-column-left-or-last = { };
      };
      "Mod+Shift+H" = {
        move-column-left = { };
      };
      "Mod+Ctrl+H" = {
        consume-or-expel-window-left = { };
      };
      "Mod+L" = {
        focus-column-right-or-first = { };
      };
      "Mod+Shift+L" = {
        move-column-right = { };
      };
      "Mod+Ctrl+L" = {
        consume-or-expel-window-right = { };
      };
      "Mod+K" = {
        focus-window-or-workspace-up = { };
      };
      "Mod+Shift+K" = {
        move-window-up-or-to-workspace-up = { };
      };
      "Mod+Ctrl+K" = {
        move-workspace-up = { };
      };
      "Mod+J" = {
        focus-window-or-workspace-down = { };
      };
      "Mod+Shift+J" = {
        move-window-down-or-to-workspace-down = { };
      };
      "Mod+Ctrl+J" = {
        move-workspace-down = { };
      };

      # Floating
      "Mod+G" = {
        toggle-window-floating = { };
      };
      "Mod+Shift+G" = {
        switch-focus-between-floating-and-tiling = { };
      };

      # Monitor actions
      "Mod+Comma" = {
        focus-monitor-next = { };
      };
      "Mod+Shift+Comma" = {
        move-window-to-monitor-next = { };
      };
      "Mod+Ctrl+Comma" = {
        move-workspace-to-monitor-next = { };
      };
      "Mod+Period" = {
        focus-monitor-previous = { };
      };
      "Mod+Shift+Period" = {
        move-window-to-monitor-previous = { };
      };
      "Mod+Ctrl+Period" = {
        move-workspace-to-monitor-previous = { };
      };

      # Screencasting
      "Mod+C" = {
        set-dynamic-cast-window = { };
      };
      "Mod+Shift+C" = {
        set-dynamic-cast-monitor = { };
      };
      "Mod+Ctrl+C" = {
        clear-dynamic-cast-target = { };
      };

      # Screenshot
      "Print" = {
        screenshot = { };
      };
      "Shift+Print" = {
        screenshot-window = { };
      };
      "Ctrl+Print" = {
        screenshot-screen = { };
      };
      # flameshot does not work very well in niri
      # https://github.com/YaLTeR/niri/issues/2309
      "Shift+Ctrl+Print" = mkSpawn [
        "flameshot"
        "gui"
      ];

      # Misc
      "Mod+W" = {
        toggle-overview = { };
      };
      # "Mod+T" = {
      #   toggle-column-tabbed-display = { };
      # };
      "Mod+N" = mkSpawn [
        "dunstctl"
        "set-paused"
        "toggle"
      ];
      "Mod+V" = {
        spawn-sh = "cliphist list | fuzzel --dmenu --with-nth 2 --width 100 | cliphist decode | wl-copy";
      };

      # Multimedia keys
      "XF86AudioMute" = mkSpawnLocked [
        "wpctl"
        "set-mute"
        "@DEFAULT_AUDIO_SINK@"
        "toggle"
      ];
      "XF86AudioLowerVolume" = mkSpawnLocked [
        "wpctl"
        "set-volume"
        "@DEFAULT_AUDIO_SINK@"
        "5%-"
      ];
      "XF86AudioRaiseVolume" = mkSpawnLocked [
        "wpctl"
        "set-volume"
        "@DEFAULT_AUDIO_SINK@"
        "5%+"
      ];
      "XF86PowerOff" = mkSpawnLocked [
        "wpctl"
        "set-mute"
        "@DEFAULT_AUDIO_SOURCE@"
        "toggle"
      ];
      "Pause" = mkSpawnLocked [
        "wpctl"
        "set-mute"
        "@DEFAULT_AUDIO_SOURCE@"
        "toggle"
      ];
      "XF86AudioNext" = mkSpawnLocked [
        "${lib.getExe pkgs.playerctl}"
        "next"
      ];
      "XF86AudioPrev" = mkSpawnLocked [
        "${lib.getExe pkgs.playerctl}"
        "previous"
      ];
      "XF86AudioPlay" = mkSpawnLocked [
        "${lib.getExe pkgs.playerctl}"
        "play-pause"
      ];

      # Brightness keys
      "XF86MonBrightnessUp" = mkSpawn [
        "${lib.getExe pkgs.brightnessctl}"
        "set"
        "5%+"
      ];
      "XF86MonBrightnessDown" = mkSpawn [
        "${lib.getExe pkgs.brightnessctl}"
        "set"
        "5%-"
      ];

      # Quit niri
      "Mod+Ctrl+Q" = {
        quit = { };
      };
    }
    # Mod + <number> to focus/move window to that workspace
    // (lib.listToAttrs (
      flatten (
        map (i: [
          {
            name = "Mod+${toString i}";
            value = {
              "focus-workspace" = mkArgs [ i ];
            };
          }
          {
            name = "Mod+Shift+${toString i}";
            value = {
              "move-window-to-workspace" = mkArgs [ i ];
            };
          }
          {
            name = "Mod+Ctrl+${toString i}";
            value = {
              "move-column-to-workspace" = mkArgs [ i ];
            };
          }
        ]) (lib.range 1 9)
      )
    ));

    window-rule = [
      {
        geometry-corner-radius = 5;
        clip-to-geometry = true;

      }
      {
        match = [
          (mkProps { is-window-cast-target = true; })
        ];

        focus-ring = {
          active-color = lib.my.colors.red;
          inactive-color = lib.my.colors.orange;
        };
        shadow = {
          on = { };
          color = "${lib.my.colors.red}70";
        };
        tab-indicator = {
          active-color = lib.my.colors.red;
          inactive-color = lib.my.colors.orange;
        };
      }
      {
        match = [
          (mkProps { title = "flameshot"; })
        ];

        open-fullscreen = false;
        open-floating = true;
      }
      # Blur terminal
      {
        match = [
          (mkProps { app-id = "^com.mitchellh.ghostty$"; })
        ];

        background-effect = {
          blur = true;
        };
      }
    ];

    layer-rule = [
      # Prevent notifications from showing in screen captures/screen share
      {
        match = [
          (mkProps { namespace = "^notifications$"; })
        ];

        block-out-from = "screen-capture";
      }
    ];

    environment = {
      # Make Electron apps use Wayland by default
      NIXOS_OZONE_WL = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";

      # Fix some Java applications having a blank screen
      _JAVA_AWT_WM_NONREPARENTING = "1";
    };
  };
in
generate niri_config
