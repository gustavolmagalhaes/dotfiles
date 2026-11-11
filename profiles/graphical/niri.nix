# Niri + Noctalia Desktop Environment Profile
{ pkgs, ... }:
{
  modules.graphical = {
    niri.enable = true;
    noctalia.enable = true;
    fuzzel.enable = true;
  };

  modules.services = {
    greetd.enable = true;
    pipewire.enable = true;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  environment.sessionVariables = {
    BROWSER = "zen";
    FILE_MANAGER = "$TERM -e nnn";
  };
}
