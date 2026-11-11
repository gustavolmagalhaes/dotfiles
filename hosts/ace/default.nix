# Host configuration for ace
{ profiles, ... }:
{
  imports = with profiles; [
    # Desktop environment
    graphical.niri      # pulls ghostty, fuzzel, noctalia automatically

    # Browsers
    graphical.zen

    # Extra graphical tools
    graphical.nwg-displays
    graphical.seahorse
    graphical.alacritty

    # Shell
    shell.essential

    # Development
    dev.ist

    # Virtualisation
    virtualisation.vm
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Audio
  services.pipewire.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire.alsa.enable = true;
  services.pipewire.alsa.support32Bit = true;
  services.pipewire.pulse.enable = true;

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

  system.stateVersion = "26.05";
}
