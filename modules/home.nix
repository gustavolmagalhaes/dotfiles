# Home Manager configuration bridge and user account definition.
# Inspired by afsc19 and diogotcorreia.
{
  pkgs,
  options,
  config,
  lib,
  user,
  userFullName,
  ...
}:
let
  inherit (lib) mkAliasDefinitions mkOption types;
  mkOpt = type: default: mkOption { inherit type default; };
in
{
  options = {
    hm = mkOption {
      type = types.attrs;
      default = { };
      description = "Home Manager configuration for the primary user";
    };
    usr = mkOption {
      type = types.attrs;
      default = { };
      description = "NixOS user configuration for the primary user";
    };

    my = {
      homeDirectory = mkOpt types.path config.users.users.${user}.home;
      configHome = mkOpt types.path "${config.my.homeDirectory}/.config";
    };
  };

  config = {
    home-manager.users.${user} = mkAliasDefinitions options.hm;
    users.users.${user} = mkAliasDefinitions options.usr;

    usr = {
      isNormalUser = true;
      description = userFullName;
      shell = pkgs.zsh;
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
    };

    hm.home.username = user;
    hm.home.homeDirectory = config.my.homeDirectory;
    hm.programs.home-manager.enable = true;
    hm.home.stateVersion = config.system.stateVersion;
  };
}
