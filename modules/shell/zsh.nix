# Zsh shell with starship prompt and zoxide
{ ... }:
{
  programs.zsh.enable = true;

  hm.programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" ];
    };

    history = {
      size = 10000;
      path = "$HOME/.zsh_history";
    };
  };

  hm.programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = true;
      format = "$directory$git_branch$git_status$cmd_duration$line_break$character";

      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
      };

      package.disabled = true;

      git_branch = {
        symbol = " ";
        format = "[$symbol$branch]($style) ";
      };

      git_commit.tag_symbol = " ";

      git_state.format = "[\\($state( $progress_current of $progress_total)\\)]($style) ";

      git_status = {
        format = "([$all_status$ahead_behind]($style) )";
        style = "bold red";
        conflicted = "conflicted ";
        ahead = "⇡\\($count\\) ";
        behind = "⇣\\($count\\) ";
        diverged = "⇕ ";
        up_to_date = "✓ ";
        untracked = "untracked ";
        stashed = "stashed ";
        modified = "modified ";
        staged = "staged ";
        renamed = "renamed ";
        deleted = "deleted ";
      };

      hostname = {
        ssh_only = true;
        format = "[$hostname](bold blue) ";
        disabled = false;
      };

      cmd_duration = {
        min_time = 10000;
        format = " took [$duration](bold yellow)";
      };
    };
  };

  hm.programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [ "--cmd cd" ];
  };
}
