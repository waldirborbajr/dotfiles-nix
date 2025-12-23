{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = true;

  # Kernel tuning
  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
    "fs.inotify.max_user_watches" = 524288;
  };

  services.locate.enable = true;
  services.fwupd.enable = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Sao_Paulo";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  users.users.borba = {
    isNormalUser = true;
    description = "BORBA JR W";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      helix
      wezterm
      lazygit
      gh
      stow
      rofi
      xclip
    ];
  };

  nixpkgs.config.allowUnfree = true;

  # =========================================================
  # 📦 System packages (dev & LSPs)
  # =========================================================
  environment.systemPackages = with pkgs; [
    git
    fzf
    ripgrep
    bat
    fd

    # LSPs
    nil
    gopls

    # Go toolchain
    go
    gofumpt
    golangci-lint

    # Nix formatter
    nixfmt
  ];

  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };

  environment.shellAliases = {
    ll = "ls -lah";
    gs = "git status";
    gp = "git pull";
    nixr = "sudo nixos-rebuild switch";
  };

  programs.git = {
    enable = true;
    config = {
      user.name = "waldirborbajr";
      user.email = "wborbajr@gmail.com";
    };
  };

  # =========================================================
  # 🔐 Security
  # =========================================================
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  services.fail2ban.enable = true;

  security.sudo = {
    enable = true;
    wheelNeedsPassword = true;
  };

  networking.firewall.allowedTCPPorts = [ 22 ];

  # =========================================================
  # 🧠 HELIX — Languages + LSP
  # =========================================================
  environment.etc."helix/languages.toml".text = ''
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

  # =========================================================
  # ⌨️ HELIX — Keybindings
  # =========================================================
  environment.etc."helix/config.toml".text = ''
[editor]
line-number = "relative"
mouse = true
auto-save = true
idle-timeout = 0

[editor.lsp]
display-messages = true

[keys.normal]
"K" = "hover"
"gd" = "goto_definition"
"gD" = "goto_declaration"
"gr" = "goto_references"
"gi" = "goto_implementation"
"gt" = "goto_type_definition"
"rn" = "rename_symbol"
"ga" = "code_action"
"]d" = "goto_next_diag"
"[d" = "goto_prev_diag"
"gf" = "format"
"gs" = "signature_help"

[keys.insert]
"C-space" = "completion"
'';

environment.etc."wezterm/wezterm.lua".text = ''
local wezterm = require 'wezterm'

return {
  -- Usa o shell padrão do usuário (zsh)
  default_prog = { "zsh" },

  -- Qualidade de vida
  hide_tab_bar_if_only_one_tab = true,
  color_scheme = "Gruvbox Dark",
  window_decorations = "RESIZE",
  scrollback_lines = 10000,

  -- Performance
  front_end = "WebGpu",
}
'';

environment.variables.TERMINAL = "wezterm";


  # =========================================================
  # 🧹 Nix maintenance
  # =========================================================
  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [ "nix-command" "flakes" ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  system.stateVersion = "25.11";
}
