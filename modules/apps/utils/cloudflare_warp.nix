{ lib, config, pkgs, ... }:
lib.my.mkModule { inherit config; } "apps.utils.cloudflare_warp" "Cloudflare Zero Trust Client" {
  hm.home.packages = with pkgs; [
    cloudflare-warp
  ];

  services.cloudflare-warp.enable = true;
}
