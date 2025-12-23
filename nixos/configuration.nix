{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = true;

  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
    "fs.inotify.max_user_watches" = 524288;
  };

  services.locate.enable = true;
  services.fwupd.enable = true;

  networking.hostName = "caveos";
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

  services.xserver.xkb.layout = "us";

  users.users.borba = {
    isNormalUser = true;
    description = "BORBA JR W";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  nixpkgs.config.allowUnfree = true;

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

    nixfmt
  ];

  programs.zsh.enable = true;

  programs.git.enable = true;

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

  # Enable flakes and nifx-command
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 1d";
    };
  };

  system.stateVersion = "25.11";
}
