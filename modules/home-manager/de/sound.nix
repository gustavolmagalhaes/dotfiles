{config, pkgs, ...}:
{
  home.packages = with pkgs; [
    pavucontrol     # Standard graphical volume mixer
    pwvucontrol     # Modern GTK4/Adwaita volume control alternative for PipeWire
    pulseaudio
  ];
}
