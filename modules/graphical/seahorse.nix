{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.graphical.seahorse;
in
{
  options.modules.graphical.seahorse.enable = mkEnableOption "Seahorse Keyring Manager";

  config = mkIf cfg.enable {
    hm.home.packages = with pkgs; [
      seahorse
      libsecret
    ];
  };
}
