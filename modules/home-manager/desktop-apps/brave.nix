{ inputs, config, pkgs, ... }:
{
  imports = [
    inputs.zen-browser.homeModules.beta
  ];

  # programs.chromium = {
  #   enable = true;
  #   package = pkgs.brave;

  # };

  programs.zen-browser = {
    enable = true;
  };
}
