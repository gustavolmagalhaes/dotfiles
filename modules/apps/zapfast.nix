{ lib, config, pkgs, ... }:
lib.my.mkModule { inherit config; } "apps.zapfast" "zapfast i guess" {
  hm.home.packages = with pkgs; [
    unstable.zapfast
  ];
}
