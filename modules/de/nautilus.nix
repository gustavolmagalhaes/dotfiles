{ lib, config, pkgs, ... }:
lib.my.mkModule { inherit config; } "de.nautilus" "File Manager" {
  hm.home.packages = with pkgs; [
    nautilus
  ];
}
