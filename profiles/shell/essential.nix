# Essential shell & CLI tools
# Imported by hosts that want a full shell environment
{ pkgs, ... }:
{
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
