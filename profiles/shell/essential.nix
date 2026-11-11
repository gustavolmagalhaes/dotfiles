# Essential Shell & CLI Profile
{ pkgs, ... }:
{
  modules.shell = {
    zsh.enable = true;
    bash.enable = true;
    git.enable = true;
  };

  environment.systemPackages = with pkgs; [
    fastfetch
    nnn
    dnsutils
    nix-output-monitor
    btop
    pciutils
    usbutils
    zed-editor
  ];
}
