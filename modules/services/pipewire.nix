{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.services.pipewire;
in
{
  options.modules.services.pipewire.enable = mkEnableOption "PipeWire Audio Server";

  config = mkIf cfg.enable {
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    services.pulseaudio.enable = false;

    environment.systemPackages = with pkgs; [
      pavucontrol
      pwvucontrol
      pulseaudio
    ];
  };
}
