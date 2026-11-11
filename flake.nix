{
  description = "NixOS configuration with modules and profiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia/cachix";
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://noctalia.cachix.org"
    ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };

  outputs =
    inputs@{ ... }:
    let
      inherit (lib.my)
        mkHosts
        mkOverlays
        mkPkgs
        mkProfiles
        ;

      user = "gus";
      userFullName = "Gustavo Magalhães";
      system = "x86_64-linux";

      extraArgs = {
        inherit
          user
          userFullName
          ;
        configDir = ./config;
      };

      lib = inputs.nixpkgs.lib.extend (
        self: _super:
        import ./lib (
          {
            inherit
              inputs
              nixosConfigurations
              profiles
              pkgs
              ;
            lib = self;
          }
          // extraArgs
        )
      );

      overlays = mkOverlays ./overlays;
      pkgs = mkPkgs system overlays;

      nixosConfigurations = mkHosts ./hosts {
        inherit extraArgs overlays;
        extraModules = [
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              extraSpecialArgs = { inherit inputs; } // extraArgs;
            };
          }
        ];
      };
      profiles = mkProfiles ./profiles;
    in
    {
      inherit nixosConfigurations lib overlays;
    };
}
