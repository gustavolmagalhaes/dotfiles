{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.graphical.ghostty;
in
{
  options.modules.graphical.ghostty.enable = mkEnableOption "Ghostty Terminal";

  config = mkIf cfg.enable {
    hm.programs.ghostty = {
      enable = true;
      package = pkgs.ghostty;

      enableBashIntegration = true;
      enableFishIntegration = true;
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
  };
}
