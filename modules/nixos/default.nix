{ config, pkgs, ... }:

{
  #### Nix (fundamental)
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  #### Locale / Time
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

  #### Networking (genérico)
  networking.networkmanager.enable = true;

  #### Shell padrão
  programs.zsh.enable = true;

  #### Pacotes essenciais
  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    fzf
    ripgrep
    fd
    bat
  ];

  #### SSH básico
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  #### Firewall base
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];

  #### Segurança
  security.sudo = {
    enable = true;
    wheelNeedsPassword = true;
  };

  #### Misc
  services.locate.enable = true;
}
