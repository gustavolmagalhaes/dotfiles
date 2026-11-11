{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.graphical.alacritty;
in
{
  options.modules.graphical.alacritty.enable = mkEnableOption "Alacritty Terminal";

  config = mkIf cfg.enable {
    hm.programs.alacritty = {
      enable = true;
      settings = {
        window.decorations = "None";
        env.term = "xterm-256color";
        font = {
          size = 12;
          draw_bold_text_with_bright_colors = true;
        };
        scrolling.multiplier = 5;
        selection.save_to_clipboard = true;
      };
    };
  };
}
