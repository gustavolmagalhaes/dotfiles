{ pkgs, ... }:
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.variables.EDITOR = "nvim";

  environment.systemPackages = with pkgs; [
    neovim
    wget
    git
    wl-clipboard
  ];

  environment.shellAliases = {
    sigma = "echo sgima";
  };
}
