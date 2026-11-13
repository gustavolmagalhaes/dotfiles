{ lib, inputs, config, pkgs, ... }:
lib.my.mkModule {inherit config;} "apps.steam" "Spotify i guess" {
  hm.programs.steam = {
    enable = true;
  };
}
