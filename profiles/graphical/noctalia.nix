# Noctalia desktop shell
{ pkgs, inputs, ... }:
{
  nix.settings = {
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };

  environment.systemPackages = [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  home-manager.sharedModules = [
    inputs.noctalia.homeModules.default
  ];

  hm.programs.noctalia = {
    enable = true;
    systemd.enable = true;

    settings = {
      theme.mode = "dark";

      bar.default = {
        position = "top";
        thickness = 36;
        background = "#000000";
        margin = 0;
        rounding = 0;
      };

      bar.widgets = {
        left = [
          { id = "Launcher"; }
          { id = "Workspace"; }
        ];
        center = [
          { id = "MediaPlayer"; }
        ];
        right = [
          { id = "Tray"; }
          { id = "Network"; }
          { id = "Volume"; }
          { id = "Brightness"; }
          { id = "Battery"; }
          { id = "Clock"; }
          { id = "ControlCenter"; }
        ];
      };
    };
  };
}
