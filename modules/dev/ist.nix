{lib,config,pkgs,...}:
lib.my.mkModule { inherit config; } "dev.ist" "Development Environment IST" {
  hm.home.packages = with pkgs; [
    swi-prolog
    scryer-prolog
  ];
}
