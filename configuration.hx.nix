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
       
       # Nix development tools
       nil           # Nix Language Server
       nixpkgs-fmt   # Nix formatter
       statix        # Nix linter
       deadnix       # Find unused Nix code
       
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

  # Helix editor configuration
  programs.helix = {
    enable = true;
    
    settings = {
      theme = "catppuccin_mocha";
      
      editor = {
        line-number = "relative";
        cursorline = true;
        color-modes = true;
        indent-guides.render = true;
        lsp.display-messages = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        file-picker.hidden = false;
        statusline = {
          left = ["mode" "spacer" "spinner" "file-name" "read-only-indicator" "file-modification-indicator"];
          center = [];
          right = ["diagnostics" "selections" "position" "file-encoding" "file-line-ending" "file-type"];
          separator = "│";
        };
      };
      
      keys.normal = {
        space = {
          r = ":run-shell-command cargo run";
          t = ":run-shell-command cargo test";
          b = ":run-shell-command cargo build";
        };
      };
    };
    
    # Language servers configuration
    languages = {
      language-server = {
        gopls = {
          command = "${pkgs.gopls}/bin/gopls";
          config = {
            gopls = {
              staticcheck = true;
              usePlaceholders = true;
              completeUnimported = true;
              analyses = {
                unusedparams = true;
                unusedwrite = true;
              };
            };
          };
        };
        
        nil = {
          command = "${pkgs.nil}/bin/nil";
          config = {
            nil = {
              formatting.command = ["${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt"];
              nix.flake.autoArchive = true;
              nix.flake.autoEvalInputs = true;
            };
          };
        };
      };
      
      language = [
        {
          name = "go";
          auto-format = true;
          formatter = {
            command = "${pkgs.go}/bin/gofmt";
          };
          language-servers = [ "gopls" ];
          indent = {
            tab-width = 4;
            unit = "\t";
          };
        }
        {
          name = "nix";
          auto-format = true;
          formatter = {
            command = "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt";
          };
          language-servers = [ "nil" ];
          indent = {
            tab-width = 2;
            unit = "  ";
          };
        }
      ];
    };
    
    # Themes (optional, but recommended)
    themes = {
      catppuccin_mocha = {
        inherits = "catppuccin_mocha";
        "ui.background" = { };
        "ui.linenr" = { fg = "#6c7086"; };
        "ui.linenr.selected" = { fg = "#f5e0dc"; bg = "#313244"; };
        "ui.statusline" = { fg = "#cdd6f4"; bg = "#1e1e2e"; };
        "ui.statusline.inactive" = { bg = "#181825"; fg = "#6c7086"; };
        "ui.statusline.normal" = { bg = "#cba6f7"; fg = "#1e1e2e"; };
        "ui.statusline.insert" = { bg = "#a6e3a1"; fg = "#1e1e2e"; };
        "ui.statusline.select" = { bg = "#f9e2af"; fg = "#1e1e2e"; };
      };
    };
  };

  # Environment variables for Go (system-wide)
  environment.variables = {
    GOPATH = "/home/borba/go";
    GO111MODULE = "on";
    GOPROXY = "https://proxy.golang.org,direct";
    GOSUMDB = "sum.golang.org";
    HELIX_RUNTIME = "/home/borba/.config/helix/runtime"; # For custom Helix config
  };

  # Create Helix configuration directory and config file
  system.activationScripts.helixConfig = {
    text = ''
      mkdir -p /home/borba/.config/helix
      
      # Create basic Helix config if it doesn't exist
      if [ ! -f /home/borba/.config/helix/config.toml ]; then
        cat > /home/borba/.config/helix/config.toml << 'EOF'
# Helix configuration
theme = "catppuccin_mocha"

[editor]
line-number = "relative"
mouse = false
bufferline = "multiple"
color-modes = true
cursorline = true
cursorcolumn = true
idle-timeout = 500
scrolloff = 8
shell = ["zsh", "-c"]
true-color = true

[editor.statusline]
left = ["mode", "spacer", "diagnostics", "version-control", "spacer", "file-name"]
center = []
right = ["position", "spacer", "file-encoding", "file-line-ending", "file-type"]
separator = "│"
mode.normal = "NORMAL"
mode.insert = "INSERT"
mode.select = "SELECT"

[editor.lsp]
display-messages = true

[editor.cursor-shape]
insert = "bar"
normal = "block"
select = "underline"

[editor.file-picker]
hidden = false

# Go specific keybindings
[keys.normal]
g = {
  d = "goto_definition",
  r = "goto_reference",
  i = "goto_implementation",
  D = "hover",
  h = "show_help",
}

[keys.normal.space]
g = ":run-shell-command go run ."
b = ":run-shell-command go build ."
t = ":run-shell-command go test ./..."
f = ":run-shell-command go fmt ."
i = ":run-shell-command goimports -w ."

# Nix specific keybindings
[keys.normal.space]
n = ":run-shell-command nix build"
s = ":run-shell-command nix shell"
d = ":run-shell-command nix develop"
f = ":run-shell-command nixpkgs-fmt ."

EOF
      fi
      
      # Create language configuration
      if [ ! -f /home/borba/.config/helix/languages.toml ]; then
        cat > /home/borba/.config/helix/languages.toml << 'EOF'
[[language]]
name = "go"
formatter = { command = "gofmt", args = [] }
language-servers = ["gopls"]
auto-format = true
indent = { tab-width = 4, unit = "\t" }

[[language]]
name = "nix"
formatter = { command = "nixpkgs-fmt" }
language-servers = ["nil"]
auto-format = true
indent = { tab-width = 2, unit = "  " }

[[language]]
name = "gomod"
scope = "source.go.mod"
file-types = ["go.mod"]
roots = ["go.mod"]
language-servers = ["gopls"]

[[language]]
name = "gosum"
scope = "source.gosum"
file-types = ["go.sum"]
roots = ["go.sum"]

[[language]]
name = "gotmpl"
scope = "source.gotmpl"
file-types = ["gotmpl", "go.tmpl", "tmpl"]
injection-regex = "gotmpl"
language-servers = ["gopls"]

EOF
      fi
      
      # Download Helix runtime (themes, queries, etc.)
      if [ ! -d /home/borba/.config/helix/runtime ]; then
        mkdir -p /home/borba/.config/helix/runtime
        # Clone helix runtime if needed
        # git clone https://github.com/helix-editor/helix /home/borba/.config/helix/runtime
      fi
      
      # Set ownership
      chown -R borba:users /home/borba/.config/helix
    '';
    deps = [];
  };

  # Shell configuration for Go and Helix
  programs.zsh = {
    enable = true;
    shellInit = ''
      # Go environment setup
      export GOPATH="$HOME/go"
      export PATH="$PATH:$GOPATH/bin"
      export GOBIN="$GOPATH/bin"
      export HELIX_RUNTIME="$HOME/.config/helix/runtime"
      
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
      alias goif='goimports -w'
      
      # Helix aliases
      alias hx='helix'
      alias hxg='helix .'  # Open current directory in helix
      alias hxn='helix ~/.config/nixpkgs/configuration.nix'  # Quick edit nix config
      
      # Nix development aliases
      alias nrb='sudo nixos-rebuild switch --flake ~/.config/nixpkgs'
      alias nrs='sudo nixos-rebuild switch'
      alias ncg='nix-collect-garbage -d'
      alias nup='sudo nix-channel --update && sudo nixos-rebuild switch'
      
      # Function to create a new Go project with Helix
      new-go-project() {
        if [ -z "$1" ]; then
          echo "Usage: new-go-project <project-name>"
          return 1
        fi
        mkdir -p "$HOME/go/src/$1"
        cd "$HOME/go/src/$1"
        go mod init "$1"
        cat > main.go << 'EOF'
package main

import "fmt"

func main() {
    fmt.Println("Hello, $1!")
}
EOF
        helix .
      }
      
      # Function to run Go tests in current directory
      goruntests() {
        go test ./... -v | grep -E "(PASS|FAIL|Error)"
      }
      
      # Function to format all Go files in project
      goformat() {
        gofmt -w .
        goimports -w .
      }
    '';
    
    # Oh My Zsh with Go plugins
    ohMyZsh = {
      enable = true;
      plugins = [ "git" "golang" "docker" "history" "z" "helix" ];
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
    core.editor = "helix";  # Set Helix as default git editor
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
