{ pkgs, ... }:

{
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

    languages = {
      language = [
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
  };

  home.packages = with pkgs; [
    helix
    nil
    nixfmt-rfc-style
    gopls
  ];
}
