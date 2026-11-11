# Zen browser
{ inputs, ... }:
{
  home-manager.sharedModules = [
    inputs.zen-browser.homeModules.default
  ];

  hm.programs.zen-browser.enable = true;
}
