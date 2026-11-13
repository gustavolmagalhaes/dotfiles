{ lib, config, pkgs, ... }:
lib.my.mkModule { inherit config; } "hardware.bluetooth" "Bluetooth pretty self explanatory" {
  # Enable bluetooth stack
  hardware.bluetooth.enable = true;

  hm.home.packages = with pkgs; [
    # Enable bluetooth TUI
    bluetui
  ];

  # Preserve paired devices across reboots (on root-on-tmpfs systems)
  # modules.impermanence.directories = [
  #   "/var/lib/bluetooth"
  # ];
}
