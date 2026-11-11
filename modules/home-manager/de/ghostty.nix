{pkgs,...}:
{
  programs.ghostty = {
    enable = true;

    # Automatically pick the correct package for Linux vs macOS
    package = pkgs.ghostty;

    # Enable shell integrations (optional, enabled by default for active shells)
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;

    # Main Ghostty configuration options
    settings = {
      theme = "Abernathy";
      background-opacity = 0.95;
      font-size = 11;
      font-family = "JetBrainsMono Nerd Font";
      window-theme = "dark";
      macos-option-as-alt = true; # Useful if you are on macOS

      window-decoration = false;

    # Custom keybindings (optional)
      keybind = [
        "super+c=copy_to_clipboard"
        "super+v=paste_from_clipboard"
      ];
    };
  };
}
