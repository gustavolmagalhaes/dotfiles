{
  inputs,
  lib,
  nixosConfigurations ? { },
  profiles ? { },
  ...
}@args:
let
  inherit (lib.my) listModulesRecursive' rakeLeaves;

  mkPkgs =
    system: overlays:
    let
      argsPkgs = {
        inherit system;
        config.allowUnfree = true;
      };
    in
    import inputs.nixpkgs (
      {
        overlays = lib.attrValues overlays;
      }
      // argsPkgs
    );

  mkOverlays =
    overlaysDir:
    if builtins.pathExists overlaysDir then
      lib.mapAttrsRecursive (_: module: import module { inherit lib rakeLeaves inputs; }) (
        rakeLeaves overlaysDir
      )
    else
      { };

  mkProfiles = profilesDir: rakeLeaves profilesDir;

  mkHost =
    hostname:
    {
      hostPath,
      system,
      pkgs,
      extraArgs ? { },
      extraModules ? [ ],
      ...
    }:
    lib.nixosSystem {
      inherit system pkgs lib;
      specialArgs = {
        inherit profiles inputs nixosConfigurations;
      }
      // extraArgs;
      modules =
        (lib.collect builtins.isPath (rakeLeaves ../modules))
        ++ [
          { networking.hostName = hostname; }
          hostPath
        ]
        ++ extraModules;
    };

  mkHosts =
    hostsDir:
    {
      extraArgs ? { },
      extraModules ? [ ],
      systems ? { },
      overlays ? { },
      ...
    }:
    lib.pipe (builtins.readDir hostsDir) [
      (lib.filterAttrs (path: _: !(lib.hasPrefix "_" path)))
      (lib.mapAttrs' (
        name: type:
        let
          hostPath = hostsDir + "/${name}";
          configPath = hostPath + "/configuration.nix";
          hostname = lib.removeSuffix ".nix" (builtins.baseNameOf hostPath);

          extraHostModules =
            if type == "directory" then
              (lib.filter (p: p != hostPath + "/configuration.nix") (listModulesRecursive' hostPath))
            else
              [ ];

          system = systems.${hostname} or "x86_64-linux";
          hostPkgs = mkPkgs system overlays;

          cfg = {
            inherit
              extraArgs
              hostPath
              inputs
              profiles
              system
              ;

            pkgs = hostPkgs;

            extraModules = extraHostModules ++ extraModules;
          }
          // hostCfg;

          hostCfg = lib.optionalAttrs (type == "directory" && builtins.pathExists configPath) (
            import configPath args
          );
        in
        lib.nameValuePair hostname (mkHost hostname cfg)
      ))
    ];
in
{
  inherit
    mkPkgs
    mkOverlays
    mkProfiles
    mkHosts
    ;
}
