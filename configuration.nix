{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = true;

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
      fzf
      ripgrep
      bat
      fd
      rofi
      xclip
      
      # Helix LSPs
      nil
      gopls
      
      # Go toolchain (performance do gopls)
      go
      gofumpt
      golangci-lint
      
      # Formatter Nix
      nixfmt
    ];
  };

  nixpkgs.config.allowUnfree = true;

  # 🔧 Pacotes do sistema + LSPs
  environment.systemPackages = with pkgs; [
    git
  ];

  programs.zsh.enable = true;

  programs.git = {
    enable = true;
    config = {
      user.name = "waldirborbajr";
      user.email = "wborbajr@gmail.com";
    };
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };

  networking.firewall.allowedTCPPorts = [ 22 ];

  # =========================================================
  # 🧠 HELIX — Languages + LSP (global)
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
# ⚡ Performance tuning
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
  # ⌨️ HELIX — Keybindings LSP
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
# Hover
"K" = "hover"

# Go to
"gd" = "goto_definition"
"gD" = "goto_declaration"
"gr" = "goto_references"
"gi" = "goto_implementation"
"gt" = "goto_type_definition"

# Rename
"rn" = "rename_symbol"

# Code actions
"ga" = "code_action"

# Diagnostics
"]d" = "goto_next_diag"
"[d" = "goto_prev_diag"

# Formatting
"gf" = "format"

# Signature help
"gs" = "signature_help"

[keys.insert]
"C-space" = "completion"
'';

  system.stateVersion = "25.11";
}
