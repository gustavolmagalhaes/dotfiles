{
  inputs,
  lib,
  nixosConfigurations ? { },
  profiles ? { },
  ...
}@args:
let
  inherit (lib.my) listModulesRecursive' rakeLeaves rakeLeavesWithSuffix;

  mkModule = { config }: name: description: content@{ imports ? [], ...}: #smart fix attribute set pattern matching
    let
      path = lib.splitString "." name;
      fullPath = [ "modules" ] ++ path;

      # Fetches the boolean state of the switch
      cfg = lib.getAttrFromPath fullPath config;

      cleanContent = builtins.removeAttrs content [ "imports" ];
    in {
      inherit imports;

      # Automatically builds the options.modules.hardware.bluetooth.enable tree
      options = lib.setAttrByPath (fullPath ++ [ "enable" ]) (lib.mkEnableOption description);

      # Automatically wraps your actual configuration in a mkIf block
      config = lib.mkIf cfg.enable cleanContent;
    };

  mkUmbrella = { config }: dir: name: description:
      let
        # 1. Rake the directory, excluding default.nix
        leaves = builtins.removeAttrs (rakeLeaves dir) [ "default" ];

        # 2. Build the nested attribute paths
        path = lib.splitString "." name;
        fullPath = [ "modules" ] ++ path;
        cfg = lib.getAttrFromPath fullPath config;
      in {
        # 3. Auto-import the child files
        imports = builtins.attrValues leaves;

        # 4. Generate the master switch option
        options = lib.setAttrByPath (fullPath ++ [ "enable" ]) (lib.mkEnableOption description);

        # 5. When enabled, cascade the mkDefault true state to all children
        config = lib.mkIf cfg.enable (
          lib.setAttrByPath fullPath (
            lib.mapAttrs (n: v: { enable = lib.mkDefault true; }) leaves
          )
        );
      };


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

  mkSecrets = secretsDir: rakeLeavesWithSuffix ".age" { } secretsDir;

  mkTui = cmd: "ghostty +new-window -e ${lib.escapeShellArg cmd}";
in
{
  inherit
    mkPkgs
    mkOverlays
    mkSecrets
    mkProfiles
    mkHosts
    mkModule
    mkUmbrella
    mkTui
    ;
}
