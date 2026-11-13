{ lib, inputs, config, pkgs, ... }:
lib.my.mkModule {inherit config;} "apps.prismlauncher" "Spotify i guess" {
  hm.home.packages = with pkgs; [
    prismlauncher
  ];
}
