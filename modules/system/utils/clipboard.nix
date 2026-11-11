{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    xclip
    wl-clipboard
  ];
}
