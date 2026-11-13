{ lib, config, pkgs, ... }:
lib.my.mkModule { inherit config; } "de.keyring" "Keyring"  {
  services.gnome.gnome-keyring.enable = true;
  hm.services.gnome-keyring.enable = true;

  hm.home.packages = with pkgs; [
    seahorse
    libsecret
  ];
}
