{lib,config,pkgs,secrets,configDir,...}: let
  # cert = pkgs.fetchurl {
  #     url = "https://si.tecnico.ulisboa.pt/configuracoes/cacert.crt";
  #     sha256 = "1yj2liyccwg6srxjzxfbk67wmkqdwxcx78khfi64ds8rgvs3n6hp";
  #   };
  certPath = configDir + /certs/tecnico.crt;

  ovpnFile = configDir + /vpns/tecnico.ovpn;
  ovpn = builtins.readFile ovpnFile;
  # "Borrowed" from afsc19's nixos-config
  # Extract a PEM block delimited by <tag>...</tag> from an .ovpn file.
  extract =
    tag:
    let
      afterOpen = builtins.elemAt (builtins.split "<${tag}>" ovpn) 2;
      beforeClose = builtins.elemAt (builtins.split "</${tag}>" afterOpen) 0;
      trimmed = builtins.match "[[:space:]]*(.*)[[:space:]]*" beforeClose;
    in
    builtins.elemAt trimmed 0;

  tecnicoCert = pkgs.writeText "tecnico-ca.pem" (extract "ca");
  tecnicoTa = pkgs.writeText "tecnico-tls-auth.pem" (extract "tls-auth");
in lib.my.mkModule { inherit config; } "networking.ist" "networking settings for ist" {

  age.secrets.ist-secrets-env.file = secrets.ist-secrets-env;

  networking.networkmanager.plugins = with pkgs; [
    # networkmanager-iodine
    # networkmanager-libreswan
    # networkmanager-l2tp
    # networkmanager-openconnect
    networkmanager-openvpn
    # networkmanager-sstp
    # networkmanager-strongswan
  ];


  networking.networkmanager.ensureProfiles = {
    environmentFiles = [
      config.age.secrets.ist-secrets-env.path
    ];

    profiles = {
      tecnico = {
        connection = {
          id = "tecnico";
          type = "vpn";
        };
        vpn = {
          service-type = "org.freedesktop.NetworkManager.openvpn";
          connection-type = "password";
          auth = "SHA256";
          cipher = "AES-256-CBC";
          dev = "tun";
          password-flags = "0";
          remote = "vpn.tecnico.ulisboa.pt";
          remote-cert-tls = "server";
          tls-version-min = "1.2";
          ca = "${tecnicoCert}";
          ta = "${tecnicoTa}";
          ta-dir = "0";
          username = "$WIFI_EDUROAM_IDENTITY";
        };
        vpn-secrets = {
          password = "$WIFI_EDUROAM_PASSWORD";
        };
        ipv4 = {
          method = "auto";
        };
        ipv6 = {
          method = "auto";
        };
      };

      eduroam = {
        connection = {
          id = "eduroam";
          type = "wifi";
        };
        wifi = {
          mode = "infrastructure";
          ssid = "eduroam";
        };
        wifi-security = {
          key-mgmt = "wpa-eap";
        };
        "802-1x" = {
          anonymous-identity = "$WIFI_EDUROAM_ANON_IDENTITY";
          ca-cert = "${certPath}";
          eap = "peap;";
          identity = "$WIFI_EDUROAM_IDENTITY";
          password = "$WIFI_EDUROAM_PASSWORD";
          phase2-auth = "mschapv2";
        };
        ipv4.method = "auto";
        ipv6 = {
          addr-gen-mode = "stable-privacy";
          method = "auto";
        };
      };
    };
  };

  # environment.etc.${certPath}.source = pkgs.fetchurl {
  #   url = "https://si.tecnico.ulisboa.pt/configuracoes/cacert.crt";
  #   sha256 = "1yj2liyccwg6srxjzxfbk67wmkqdwxcx78khfi64ds8rgvs3n6hp";
  # };


}
