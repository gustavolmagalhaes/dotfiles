{ config, pkgs, ... }:
{
  home.sessionVariables = {
  BROWSER = "brave";
  FILE_MANAGER = "$TERM -e nnn";
  };
}
