{ pkgs, ... }:

{
  # home.stateVersion = "25.11";

  imports = [
    ./zsh.nix
    ./helix.nix
    ./wezterm.nix
    ./git.nix
    ./zellij.nix
  ];

  home.packages = with pkgs; [
    lazygit
    gh
    stow
    rofi
    xclip
  ];

  home.sessionVariables = {
    TERMINAL = "wezterm";
    EDITOR = "hx";
  };
}
