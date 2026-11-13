{lib,config,configDir,...}:
lib.my.mkModule { inherit config; } "networking.homelab" "connect to homelab networking" {

  security.pki.certificateFiles = [
    "${configDir}/certs/viper.lan.crt"
  ];
  # environment.etc."ssl/certs/viper.lan.crt".source = configDir + /certs/viper.lan.crt;
#   networking.wirguard.interfaces.wg-home = {
#     ips = [""]
#
#     privateKeyFile =
#           config.age.secrets.wg-home.path;
#
#     peers = [{
#       publicKey = "SERVER_PUBLIC_KEY";
#       endpoint = "vpn.magellanwolf.win:51820";
#       allowedIPs = [ "10.10.0.0/24" ];
#       persistentKeepalive = 25;
#     }];
#   }

}
