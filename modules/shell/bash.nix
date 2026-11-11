{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.shell.bash;
in
{
  options.modules.shell.bash.enable = mkEnableOption "Bash Shell";

  config = mkIf cfg.enable {
    hm.programs.bash = {
      enable = true;
      enableCompletion = true;
    };
  };
}
