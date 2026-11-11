{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.services.greetd;
  theme = "text=#ffffff;time=#999999;container=#000000;border=#2a2a2a;title=#ffffff;greet=#999999;prompt=#ffffff;input=#ffffff;action=#444444;button=#ffffff";
  sessions = "${config.services.displayManager.sessionData.desktops}/share/wayland-sessions";
in
{
  options.modules.services.greetd.enable = mkEnableOption "Greetd Display Manager";

  config = mkIf cfg.enable {
    services.greetd = {
      enable = true;
      useTextGreeter = true;
      settings.default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --sessions ${sessions} --theme ${theme}";
        user = "greeter";
      };
    };

    services.gnome.gnome-keyring.enable = true;
    security.pam.services.greetd.enableGnomeKeyring = true;
    security.pam.services.login.enableGnomeKeyring = true;

    hm.services.gnome-keyring.enable = true;
  };
}
