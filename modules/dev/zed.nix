{ lib, config, pkgs, ... }: let
  cfg = config.modules.dev.zed;
in {

  options.modules.dev.zed.enable = lib.mkEnableOption "Development Environment LEIC";

  config = lib.mkIf cfg.enable {
    hm.home.packages = with pkgs; [
      zed-editor
    ];
  };
}
