{lib,config,...}:
lib.my.mkModule { inherit config; } "networking.home" "home networking" {

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
