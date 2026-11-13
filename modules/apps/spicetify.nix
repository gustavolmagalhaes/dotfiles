{ lib, inputs, config, pkgs, ... }:
lib.my.mkModule {inherit config;} "apps.spicetify" "Spotify i guess" {
  home-manager.sharedModules = [
     inputs.spicetify-nix.homeManagerModules.default
   ];


   hm.programs.spicetify = {
      enable = true;
      spotifyPackage = pkgs.spotify;

      theme = pkgs.spicetify.themes.comfy;
      colorScheme = "Comfy";

      enabledExtensions = with pkgs.spicetify.extensions; [
        fullAppDisplay
        autoSkipVideo
        shuffle # shuffle+
        hidePodcasts
      ];

      enabledCustomApps = with pkgs.spicetify.apps; [ lyricsPlus ];
    };
}
