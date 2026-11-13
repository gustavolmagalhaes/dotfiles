{ lib, config, pkgs, ... }:
lib.my.mkModule { inherit config; } "de.swaylock" "Lock Screen"  {

  # security.pam.services.swaylock = {};

  # "Borrowed" from diogotcorreia's nix files
  hm.programs.swaylock = {
    enable = true;
    settings = {
      font-size = 24;
      indicator-idle-visible = true;
      indicator-radius = 50;
      show-failed-attempts = true;
      ignore-empty-password = false;
    }
    // (with lib.my.colors; {
      # colors
      color = black;
      bs-hl-color = orange;
      key-hl-color = teal;
      caps-lock-bs-hl-color = orange;
      caps-lock-key-hl-color = teal;
      separator-color = black;
      layout-bg-color = "${black}c0";
      layout-text-color = lightwhite;

      inside-color = "${grey}c0";
      inside-clear-color = "${yellow}c0";
      inside-caps-lock-color = "${black}c0";
      inside-ver-color = "${lightblue}c0";
      inside-wrong-color = "${red}c0";

      line-color = black;
      line-clear-color = black;
      line-caps-lock-color = black;
      line-ver-color = black;
      line-wrong-color = black;

      ring-color = green;
      ring-clear-color = yellow;
      ring-caps-lock-color = yellow;
      ring-ver-color = darkblue;
      ring-wrong-color = pink;

      text-color = orange;
      text-clear-color = black;
      text-caps-lock-color = orange;
      text-ver-color = black;
      text-wrong-color = black;
    });
  };

  # TODO: Revisit once https://github.com/YaLTeR/niri/issues/108 is implemented
  hm.services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 3;
        command = "${lib.getExe' pkgs.procps "pgrep"} swaylock && ${lib.getExe pkgs.niri} msg action power-off-monitors";
      }
      {
        timeout = 300;
        command = "${lib.getExe pkgs.niri} msg action power-off-monitors";
      }
    ];
  };

}
