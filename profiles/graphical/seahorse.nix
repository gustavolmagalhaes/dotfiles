# Seahorse – GNOME keyring manager
{ pkgs, ... }:
{
  hm.home.packages = with pkgs; [
    seahorse
    libsecret
  ];
}
