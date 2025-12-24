{ pkgs, ... }:

let
  # Catppuccin themes for Helix (oficial)
  catppuccin-helix = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "helix";
    # versão estável conhecida
    rev = "b6b1b52c7e1a9d9a8e2aeb4b3b5b7f6c2d8c2c6e";
    sha256 = "sha256-m+U7E3Cz4jQeN1vH+u4R4l1Q0F0Wq4E0c7rjZ5N9XnQ=";
  };
in
{
  ############################
  # Helix
  ############################
  programs.helix = {
    enable = true;
    defaultEditor = true;

    settings = {
      theme = "catppuccin_mocha";

      editor = {
        line-number = "relative";
        mouse = true;
        auto-save = true;
        cursorline = true;
        color-modes = true;
      };
    };

    languages.language = [
      {
        name = "nix";
        auto-format = true;
        language-servers = [ "nil" ];
        formatter.command = "nixfmt-rfc-style";
      }
      {
        name = "go";
        auto-format = true;
        language-servers = [ "gopls" ];
      }
    ];
  };

  ############################
  # Catppuccin themes (Helix)
  ############################
  home.file.".config/helix/themes".source =
    "${catppuccin-helix}/themes";

  ############################
  # Tooling
  ############################
  home.packages = with pkgs; [
    helix
    nil
    nixfmt-rfc-style
    gopls
  ];
}
