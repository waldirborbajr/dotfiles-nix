{ pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      # Nix
      nil
      nixpkgs-fmt
      clang-tools
    ];
  };

  programs.helix = {
    enable = true;
    languages = {
      language = [
        {
          name = "nix";
          auto-format = true;
          formatter.command = "alejandra";
          language-servers = [ "nil" ];
          indent.tab-width = 2;
          indent.unit = " ";
        }
        {
          name = "rust";
          auto-format = true;
          indent = {
            tab-width = 2;
            unit = "	";
          };
        }
        {
          name = "go";
          auto-format = true;
          formatter = {
            command = "gofumpt";
          };
          language-servers = [
            "gopls"
            "golangci-lint-ls"
          ];
          indent = {
            tab-width = 2;
            unit = "	";
          };
        }
      ];
      language-server = {
        nixd.command = "${pkgs.nixd}/bin/nixd";
        gopls = {
          command = "${pkgs.gopls}/bin/gopls";
          config = {
            gopls = {
              staticcheck = true;
              completeUnimported = true;
              matcher = "fuzzy";
              symbolMatcher = "fuzzy";
              experimentalPostfixCompletions = true;
              gofumpt = true;
              build.expandWorkspaceToModule = true;
              analyses = {
                unusedparams = true;
                unusedwrite = true;
                unusedvariable = true;
                fieldalignment = true;
                nilness = true;
                shadow = true;
                unusedresult = true;
              };
              codelenses = {
                generate = true;
                gc_details = true;
                test = true;
                tidy = true;
                upgrade_dependency = true;
                vendor = true;
                run_govulncheck = true;
              };
              hints = {
                assignVariableTypes = true;
                compositeLiteralFields = true;
                compositeLiteralTypes = true;
                constantValues = true;
                functionTypeParameters = true;
                parameterNames = true;
                rangeVariableTypes = true;
              };
              usePlaceholders = true;
            };
          };
        };
        golangci-lint-ls = {
          command = "${pkgs.golangci-lint-langserver}/bin/golangci-lint-langserver";
        };
      };
    };
    settings = {
      theme = "catppuccin_mocha";
      editor = {
        line-number = "relative";
        cursorline = true;
        bufferline = "always";
        color-modes = true;
        cursor-shape.insert = "bar";
        cursor-shape.normal = "block";
        cursor-shape.select = "underline";
        # indent-guides.render = true;
        # indent-guides.character = "┊";
        indent-guides.skip-levels = 1;
        shell = [
          "zsh"
          "-c"
        ];
        scroll-lines = 6;
        completion-trigger-len = 2;
        text-width = 80;
        auto-completion = true;
        auto-format = true;
        completion-replace = true;
        auto-save = {
          focus-lost = true;
          after-delay.enable = true;
        };
        auto-info = true;
        true-color = true;
        popup-border = "all";
        lsp = {
          enable = true;
          display-messages = true;
          display-inlay-hints = true;
          auto-signature-help = true;
          snippets = true;
        };
        soft-wrap = {
          enable = false;
          wrap-at-text-width = true;
        };
        file-picker = {
          hidden = true;
          parents = false;
          git-ignore = false;
          git-exclude = false;
          git-global = true;
          max-depth = 4;
        };
        whitespace.render = "all";
      };
      keys = {
        normal = {
          space = {
            W = ":toggle-option soft-wrap.enable";
            q = ":reflow";
          };
        };
        select = {
          space = {
            q = ":reflow";
          };
        };
        insert = {
          C-c = "normal_mode";
          "C-[" = "normal_mode";
        };
      };
    };
  };
}
