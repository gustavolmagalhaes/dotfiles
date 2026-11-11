{config, pkgs, ...}:
{

  imports = [
    # ./shell-aliases.nix
    ./starship.nix
    ./zoxide.nix
  ];


  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = ["git" "sudo"];
    };

    history = {
      size = 10000;
      path = "$HOME/.zsh_history";
    };
  };
}
