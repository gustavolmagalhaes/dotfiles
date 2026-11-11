{ inputs, config, pkgs, ...}:
{
  home.packages = with pkgs; [
    swi-prolog ## LP Prolog
    scryer-prolog ## Prolog in Rust
  ];
}
