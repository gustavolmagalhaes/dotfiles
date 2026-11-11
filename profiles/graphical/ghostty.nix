# Ghostty terminal emulator
{ pkgs, ... }:
{
  hm.programs.ghostty = {
    enable = true;
    package = pkgs.ghostty;

    enableBashIntegration = true;
    enableZshIntegration = true;

    settings = {
      theme = "Abernathy";
      background-opacity = 0.95;
      font-size = 11;
      font-family = "JetBrainsMono Nerd Font";
      window-theme = "dark";
      macos-option-as-alt = true;
      window-decoration = false;

      keybind = [
        "super+c=copy_to_clipboard"
        "super+v=paste_from_clipboard"
      ];
    };
  };
}
