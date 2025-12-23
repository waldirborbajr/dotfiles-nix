{ pkgs, ... }:

{
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    helix
    wezterm
    lazygit
    gh
    stow
    rofi
    xclip
  ];

  home.sessionVariables = {
    TERMINAL = "wezterm";
  };

  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      ll = "ls -lah";
      gs = "git status";
      gp = "git pull";
      nixr = "sudo nixos-rebuild switch --flake /etc/nixos";
      nixs = "sudo nixos-rebuild switch --flake '.#caveos'";
      nixb = "sudo nixos-rebuild build  --flake '.#caveos'";
      nixd = "sudo nixos-rebuild dry-build --flake '.#caveos'";
    };
  };

  programs.git = {
    enable = true;
    userName = "waldirborbajr";
    userEmail = "wborbajr@gmail.com";
  };

  # ===============================
  # Helix
  # ===============================
  home.file.".config/helix/languages.toml".text = ''
[[language]]
name = "nix"
language-servers = ["nil"]
formatter = { command = "nixfmt" }
auto-format = true

[[language]]
name = "go"
language-servers = ["gopls"]
auto-format = true

[language-server.gopls]
command = "gopls"

[language-server.gopls.config]
analyses = {
  unusedparams = true,
  unusedwrite = true,
  nilness = true
}
staticcheck = false
usePlaceholders = true
completeUnimported = true
deepCompletion = false
matcher = "Fuzzy"
symbolMatcher = "FastFuzzy"
semanticTokens = true
memoryMode = "DegradeClosed"
directoryFilters = ["-**/vendor", "-**/node_modules"]
'';

  home.file.".config/helix/config.toml".text = ''
[editor]
line-number = "relative"
mouse = true
auto-save = true

[keys.normal]
"K" = "hover"
"gd" = "goto_definition"
"gr" = "goto_references"
"rn" = "rename_symbol"
"ga" = "code_action"
'';

  # ===============================
  # WezTerm
  # ===============================
  home.file.".config/wezterm/wezterm.lua".text = ''
local wezterm = require 'wezterm'

return {
  default_prog = { "zsh" },
  hide_tab_bar_if_only_one_tab = true,
  color_scheme = "Gruvbox Dark",
  front_end = "WebGpu",
}
'';
}
