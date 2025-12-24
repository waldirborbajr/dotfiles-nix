{ pkgs, ... }:

{
  home.stateVersion = "25.11";

  imports = [
    ./zsh/zsh.nix
    ./helix/helix.nix
    ./wezterm/wezterm.nix
    ./git.nix
    ./zellij/zellij.nix
    ./htop.nix
    # ./nerdfonts.nix
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
