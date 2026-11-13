{ inputs, pkgs, user, ...}:
{
  imports = [
    inputs.agenix.nixosModules.default
  ];

  hm.home.packages = with pkgs; [
    agenix
    age
  ];


  age.identityPaths = [ "/home/${user}/.ssh/id_ed25519" ];

}
