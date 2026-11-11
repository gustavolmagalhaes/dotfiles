{ config, pkgs, inputs, ... }:
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia = {
    enable = true;
    systemd.enable = true;

    settings = {
      theme = {
        mode = "dark";
      };

      # Top Bar Layout and Styling Configuration
      bar = {
        default = {
          position = "top";
          thickness = 36;
          background = "#000000";
          margin = 0;
          rounding = 0;
        };

        widgets = {
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
  };
}
