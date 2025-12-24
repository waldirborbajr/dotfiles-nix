{ pkgs, ... }:

{
  programs.zellij = {
    enable = true;
    enableZshIntegration = true;
      settings = {
        show_startup_tips = false;
        theme = pkgs.themes.zellij;
      };
  };
}
