{ pkgs, ... }:

{
  home.packages = [ pkgs.wezterm ];

  home.file.".config/wezterm/wezterm.lua".text = ''
    local wezterm = require 'wezterm'

    return {
      default_prog = { "zsh" },
      hide_tab_bar_if_only_one_tab = true,
      color_scheme = "Catppuccin Mocha",
      front_end = "WebGpu",
    }
  '';
}
