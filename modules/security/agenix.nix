{ lib, user, config, pkgs, inputs, ... }:
lib.my.mkModule { inherit config; } "security.agenix" "Secret Management" {

  imports = [
    inputs.agenix.nixosModules.default
  ];


  hm.home.packages = with pkgs; [
    agenix
    # age
  ];


  age.identityPaths = [ "/home/${user}/.ssh/id_ed25519" ];

}
