# Host configuration for ace
{ profiles, inputs, ... }:
{

  imports = with profiles; [
    laptop



    # Desktop environment
    # graphical.niri      # pulls ghostty, fuzzel, noctalia automatically

    # Browsers
    # graphical.zen

    # Extra graphical tools
    # graphical.nwg-displays
    # graphical.seahorse
    graphical.alacritty

    # Shell
    shell.essential

    # Development
  ];

  # Bootloader
  #
  boot.loader = {
    efi.canTouchEfiVariables = true;
  }
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Audio
  services.pipewire.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire.alsa.enable = true;
  services.pipewire.alsa.support32Bit = true;
  services.pipewire.pulse.enable = true;

  services.gvfs.enable = true;

  # Networking
  networking.networkmanager.enable = true;

  # Timezone and Localization
  time.timeZone = "Europe/Lisbon";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_PT.UTF-8";
    LC_IDENTIFICATION = "pt_PT.UTF-8";
    LC_MEASUREMENT = "pt_PT.UTF-8";
    LC_MONETARY = "pt_PT.UTF-8";
    LC_NAME = "pt_PT.UTF-8";
    LC_NUMERIC = "pt_PT.UTF-8";
    LC_PAPER = "pt_PT.UTF-8";
    LC_TELEPHONE = "pt_PT.UTF-8";
    LC_TIME = "pt_PT.UTF-8";
  };

  # Console & X11 Keymap
  services.xserver.xkb = {
    layout = "pt";
    variant = "";
  };
  console.keyMap = "pt-latin1";

  # Monitors
  my.config = {
    security = {
      ir_camera_path = "/dev/video2";
    };

    graphical.monitors = [
      {
        name = "eDP-1"; # 1920x1200
        primary = true;
        position = {
          x = 0;
          y = 0;
        };
      }
      {
        name = "HDMI-A-1";
        position = {
          x = 1536;
          y = 0;
        };
      }
    ];
  };

#   age.identityPaths = ["/home/gus/.ssh/id_ed25519"];
#
#   age.secrets.baikal_password = {
#     file = ../../secrets/baikal_password.age; # Adjust path to your secrets directory
#     owner = "gus";
#   };

  system.stateVersion = "26.05";
}
