{config, pkgs, ...}:
{
  home.manager = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];
}
