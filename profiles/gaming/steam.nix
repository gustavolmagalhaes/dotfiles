{lib,pkgs,...}:
{
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true; # Optional
  };

  programs.gamemode.enable = true;
}
