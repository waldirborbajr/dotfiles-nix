{ pkgs, ... }:

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
      ll = "ls -lah";
      gs = "git status";
      gp = "git pull";

      nixs = "sudo nixos-rebuild switch --flake '.#caveos'";
      nixb = "sudo nixos-rebuild build  --flake '.#caveos'";
      nixd = "sudo nixos-rebuild dry-build --flake '.#caveos'";
    };
  };
}
