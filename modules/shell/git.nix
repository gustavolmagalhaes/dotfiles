{
  config,
  lib,
  userFullName,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.shell.git;
in
{
  options.modules.shell.git.enable = mkEnableOption "Git Version Control";

  config = mkIf cfg.enable {
    hm.programs.git = {
      enable = true;
      settings.user = {
        name = userFullName;
        email = "g.lobomagalhaes@gmail.com";
      };
    };
  };
}
