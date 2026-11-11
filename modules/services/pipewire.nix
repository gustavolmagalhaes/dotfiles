# PipeWire audio server
{ pkgs, ... }:
{
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
}
