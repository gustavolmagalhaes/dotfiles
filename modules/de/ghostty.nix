{ lib, config, pkgs, ... }:
lib.my.mkModule { inherit config; } "de.ghostty" "Terminal Emulator" {
  hm.programs.ghostty = {
    enable = true;
    package = pkgs.ghostty;

    enableBashIntegration = true;
    enableZshIntegration = true;

    settings = {
      background = "#000000";
      foreground = "#c8ccd4";
      selection-background = "#262626";
      selection-foreground = "#ffffff";
      cursor-color = "#74ade8";

      background-opacity = 1.0;

      palette = [
        "0=#000000"
        "1=#d07277"
        "2=#a1c181"
        "3=#dec184"
        "4=#5e96e9"
        "5=#c07fdc"
        "6=#6cabc8"
        "7=#c8ccd4"
        "8=#4c4c4c"
        "9=#d07277"
        "10=#a1c181"
        "11=#dec184"
        "12=#74ade8"
        "13=#c07fdc"
        "14=#6cabc8"
        "15=#ffffff"
      ];

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


#     settings = {
#       theme = "Abernathy";
#       background-opacity = 0.95;
#       font-size = 11;
#       font-family = "JetBrainsMono Nerd Font";
#       window-theme = "dark";
#       macos-option-as-alt = true;
#       window-decoration = false;
#
#       keybind = [
#         "super+c=copy_to_clipboard"
#         "super+v=paste_from_clipboard"
#       ];
#     };
  };
}
