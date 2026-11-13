{ lib, inputs, config, ... }:
lib.my.mkModule { inherit config; } "apps.browsers.zen" "Clipboard History" {
  home-manager.sharedModules = [
    inputs.zen-browser.homeModules.default
  ];

  hm.programs.zen-browser.enable = true;
}
