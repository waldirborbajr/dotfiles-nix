{ pkgs, ... }:

{
  programs.helix = {
    enable = true;
    defaultEditor = true;

    settings = {
      editor = {
        line-number = "relative";
        mouse = true;
        auto-save = true;
      };

      keys.normal = {
        K = "hover";
        gd = "goto_definition";
        gr = "goto_references";
        rn = "rename_symbol";
        ga = "code_action";
      };
    };

    languages = {
      language = [
        {
          name = "nix";
          formatter = {
            command = "nixfmt-rfc-style";
          };
          auto-format = true;
          language-servers = [ "nil" ];
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
