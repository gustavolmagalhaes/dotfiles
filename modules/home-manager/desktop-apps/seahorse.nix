{ config, pkgs, ...}:
{
  home.packages = with pkgs; [
    seahorse
    libsecret
  ];
}
