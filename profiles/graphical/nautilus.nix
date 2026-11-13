{ pkgs, ... }:
{
  hm.home.packages = with pkgs; [
    nautilus
  ];
}
