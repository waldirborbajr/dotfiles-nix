{ pkgs, lib, ... }:
{
  programs.zsh = {
    enable = true;
    plugins = [
      {
        name = "zsh-autosuggestions";
        src = pkgs.zsh-autosuggestions;
      }
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.zsh-syntax-highlighting;
      }
    ];
    shellAliases = {
      #### Navegação / básicos
      ll = "ls -lah";
      gs = "git status";
      gp = "git pull";
      #### NixOS rebuilds
      nixs = "sudo nixos-rebuild switch --flake '.#caveos'";
      nixb = "sudo nixos-rebuild build --flake '.#caveos'";
      nixd = "sudo nixos-rebuild dry-build --flake '.#caveos'";
      nixt = "sudo nixos-rebuild test --flake '.#caveos'";
      #### Garbage collection
      nixgc = "sudo nix-collect-garbage -d";
      nixgcu = "nix-collect-garbage -d";
      nixstore = "sudo nix-store --optimise";
      #### Gerações
      nixgen = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
      nixold = "sudo nix-env --delete-generations old --profile /nix/var/nix/profiles/system";
      #### Flakes
      nixflake = "nix flake show";
      nixlock = "nix flake lock --recreate-lock-file";
      nixupdate = "nix flake update";
      #### Debug / recovery
      nixtrace = "sudo nixos-rebuild switch --show-trace --flake '.#caveos'";
      nixrollback = "sudo nixos-rebuild switch --rollback";
      #### Info
      nixwhy = "nix why-depends";
      nixsize = "nix path-info -Sh /run/current-system";
    };
    initContent = ''
      nix-clean-all() {
        echo "→ Nix: garbage collection (root)"
        sudo nix-collect-garbage -d
        echo "→ Nix: garbage collection (user)"
        nix-collect-garbage -d
        echo "→ Nix: optimise store"
        sudo nix-store --optimise
        echo "→ Nix: remove old system generations"
        sudo nix-env --delete-generations old \
          --profile /nix/var/nix/profiles/system
        echo "✔ Nix cleanup complete"
      }
    '';
  };
}
