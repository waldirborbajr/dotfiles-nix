{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;

    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -lah";
      gs = "git status";
      gp = "git pull";

      nixs = "sudo nixos-rebuild switch --flake '.#caveos'";
      nixb = "sudo nixos-rebuild build  --flake '.#caveos'";
      nixd = "sudo nixos-rebuild dry-build --flake '.#caveos'";
    };
  };
}
