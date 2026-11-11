{
  pkgs,
  config,
  ...
}: {

  programs.fuzzel = {
    enable = true;

    settings = {
      main = {
        width = 50;
        inner-pad=0;
        horizontal-pad=15;
      };

      border = {
        radius=0;
      };

      colors = {
        background ="000000ff";
        text ="eeeeeeff";
        match ="ffffffff";
        selection-match ="ffffffff";
        selection-text="ffffffff";
        border="ffffff1a";
        selection="2a2a2aff";
      };
    };
  };
}
