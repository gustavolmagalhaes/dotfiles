# IST Prolog development tools
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    swi-prolog
    scryer-prolog
  ];
}
