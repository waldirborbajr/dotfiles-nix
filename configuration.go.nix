{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # Select internationalisation properties.
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

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.borba = {
    isNormalUser = true;
    description = "BORBA JR W";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
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
       
       # Go development tools (user-level packages)
       go            # Go compiler
       gopls         # Go Language Server
       delve         # Go debugger
       golangci-lint # Linter
       go-tools      # Extra tools (staticcheck, etc.)
       gotools       # Additional Go tools
       air           # Live reload for development
       richgo        # Better test output
       godoc         # Documentation server
       
       # Go web development helpers
       nodejs_20     # For frontend tooling
       yarn
       
       # Database tools
       postgresql
       sqlite
       
       # HTTP/API tools
       curl
       wget
       httpie
       
       # Container tools
       docker
       docker-compose
       
       # Build tools
       gnumake
       gcc
       cmake
       pkg-config
       
       # CLI tools for Go development
       jq
       yq-go
       upx           # Binary compression
       protobuf      # Protocol buffers
       protoc-gen-go
       protoc-gen-go-grpc
    ];
    shell = pkgs.zsh;
  };

  # Environment variables for Go (system-wide)
  environment.variables = {
    GOPATH = "/home/borba/go";
    GO111MODULE = "on";
    GOPROXY = "https://proxy.golang.org,direct";
    GOSUMDB = "sum.golang.org";
  };

  # Shell configuration for Go
  programs.zsh = {
    enable = true;
    shellInit = ''
      # Go environment setup
      export GOPATH="$HOME/go"
      export PATH="$PATH:$GOPATH/bin"
      export GOBIN="$GOPATH/bin"
      
      # Create Go directories if they don't exist
      if [ ! -d "$GOPATH" ]; then
        mkdir -p $GOPATH/{src,bin,pkg}
        echo "Created Go directories in $GOPATH"
      fi
      
      # Aliases for common Go commands
      alias gorun='go run'
      alias gob='go build'
      alias got='go test'
      alias gotv='go test -v'
      alias goc='go clean'
      alias gof='go fmt'
      alias goi='go install'
      alias gov='go version'
      alias gom='go mod'
      alias gomt='go mod tidy'
    '';
    
    # Oh My Zsh with Go plugins
    ohMyZsh = {
      enable = true;
      plugins = [ "git" "golang" "docker" "history" "z" ];
      theme = "robbyrussell";
    };
  };

  # Additional git configuration for Go
  programs.git.config = {
    user.name = "waldirborbajr";
    user.email= "wborbajr@gmail.com";
    # Useful for Go modules
    url."https://go.googlesource.com/".insteadOf = "https://go.googlesource.com/";
    url."https://github.com/".insteadOf = "https://github.com/";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    # Only essential system packages here
  ];

  # Docker service for development
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  # PostgreSQL service for database development
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    enableTCPIP = true;
    authentication = pkgs.lib.mkOverride 10 ''
      local all all trust
      host all all 127.0.0.1/32 trust
      host all all ::1/128 trust
    '';
    initialScript = pkgs.writeText "initial.sql" ''
      CREATE ROLE borba WITH LOGIN PASSWORD 'borba' CREATEDB;
      CREATE DATABASE borba OWNER borba;
      CREATE DATABASE test OWNER borba;
    '';
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 5432 8080 3000 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
