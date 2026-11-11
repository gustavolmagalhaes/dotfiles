# Host configuration for ace
{
  profiles,
  ...
}:
{
  imports = with profiles; [
    graphical.niri
    graphical.browsers
    graphical.terminals
    graphical.apps
    shell.essential
    dev.ist
    virtualisation.vm
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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
