# IST development profile
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    swi-prolog
    scryer-prolog
  ];
}
