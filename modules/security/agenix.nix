{ lib, user, config, pkgs, ... }:
lib.my.mkModule { inherit config; } "security.agenix" "Secret Management" {
  hm.home.packages = with pkgs; [
    agenix
    age
  ];


  age.identityPaths = [ "/home/${user}/.ssh/id_ed25519" ];

}
