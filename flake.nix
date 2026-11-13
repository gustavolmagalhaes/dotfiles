{
  description = "NixOS configuration with modules and profiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

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

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # noctalia = {
    #   url = "github:noctalia-dev/noctalia/cachix";
    # };

    agenix = {
      url = "github:ryantm/agenix/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    gaze = {
      url = "github:GunduLabs/gaze/v0.5.1";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
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
        mkSecrets
        ;

      user = "gus";
      userFullName = "Gustavo Magalhães";
      system = "x86_64-linux";

      # I can put extra data here
      extraArgs = {
        inherit
          user
          userFullName
          secrets
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
              secrets
              ;
            lib = self;
          }
          // extraArgs
        )
      );

      extraPackages = { system, ... }:{
        agenix = inputs.agenix.packages.${system}.default;
        spicetify = inputs.spicetify-nix.legacyPackages.${system};
        gaze = inputs.gaze.packages.${system}.default (old: {
          buildInputs = (old.buildInputs or []) ++ [
            inputs.nixpkgs.legacyPackages.${system}.zstd
          ];
        });
        unstable = import inputs.nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      };

      overlays = (mkOverlays ./overlays) // {
        extraPkgs = _self: _super: (extraPackages { system = system; });
      } // {

      };
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
          inputs.lanzaboote.nixosModules.lanzaboote
        ];
      };
      profiles = mkProfiles ./profiles;
      secrets = mkSecrets ./secrets;
    in
    {
      inherit nixosConfigurations lib overlays;
    };
}
