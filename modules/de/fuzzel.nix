{ lib, config, ... }:
lib.my.mkModule { inherit config; } "de.fuzzel" "Menu Bar" {
  hm.programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        width = 60;
        lines = 20;
        inner-pad = 0;
        horizontal-pad = 15;
      };
      border.radius = 0;
      colors = {
        background = "000000ff";
        text = "eeeeeeff";
        match = "ffffffff";
        selection-match = "ffffffff";
        selection-text = "ffffffff";
        border = "ffffff1a";
        selection = "2a2a2aff";
      };
    };
  };
}
