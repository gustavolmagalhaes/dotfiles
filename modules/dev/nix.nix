{lib,config,pkgs,...}:
lib.my.mkModule { inherit config; } "dev.nix" "Development Environment nix" {
  hm.home.packages = with pkgs; [
    nil
    nixd
  ];
}
