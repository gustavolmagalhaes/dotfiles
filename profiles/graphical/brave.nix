# Brave browser
{ pkgs, ... }:
{
  hm.programs.chromium = {
    enable = true;
    package = pkgs.brave;
  };
}
