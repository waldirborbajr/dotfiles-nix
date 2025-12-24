{ pkgs, ... }:

{
  home.stateVersion = "25.11";

  imports = [
    ./zsh.nix
    ./helix.nix
    ./wezterm.nix
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
  };

  programs.git = {
    enable = true;
    userName = "waldirborbajr";
    userEmail = "wborbajr@gmail.com";
  };
}
