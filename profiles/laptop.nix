{ profiles, ... }:
{

  modules = {
    hardware = {
      bluetooth.enable = true;
    };


    dev.enable = true;
    de.enable = true;
    apps = {
      browsers.enable = true;
      utils.enable = true;
      spicetify.enable = true;
      zapfast.enable = true;
      prismlauncher.enable = true;
    };
    security = {
      enable = true;
    };
    networking = {
      ist.enable = true;
      homelab.enable = true;
    };
  };


  hm.home.sessionVariables = {
    TERMINAL = "ghostty +new-window";
    BROWSER = "zen-beta";
    EDITOR = "zeditor";
  };
}
