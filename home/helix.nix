{ pkgs, ... }:

{

  home = {
    packages = with pkgs; [
      # Nix
      nil
      nixpkgs-fmt
      # Web
      vscode-langservers-extracted # HTML/CSS/JSON/ESLint language servers
      typescript-language-server
      svelte-language-server
      nodePackages.prettier
      nodePackages.eslint
      # Markdown
      marksman
      markdownlint-cli
      # Lua
      lua-language-server
      # Python
      pyright
      ruff-lsp
      # C#
      csharp-ls
      # C, C++
      clang-tools
      # Rust
      rust-analyzer
      rustfmt
      # SQL
      sqls
      # Haskell
      haskell-language-server
      # Bash
      bash-language-server
      # TOML
      taplo
      # Runtimes and Libraries
      lldb
      helix
    ];
  };

  programs.helix = {
    enable = false;
    # package = pkgs.helix;
    # defaultEditor = true;
    languages = {
      language = [
        # {
        #   name = "nix";
        #   language-servers = [ "nixd" ];
        # }
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
          indent = {
            tab-width = 2;
            unit = "	";
          };
        }
        {
          name = "markdown";
          auto-format = true;
          soft-wrap.enable = true;
          soft-wrap.wrap-at-text-width = true;
          language-servers = [ "markdown-oxide" "ltex-ls" ];
        }
      ];
      language-server = {
        nixd.command = "${pkgs.nixd}/bin/nixd";
        markdown-oxide.command = "${pkgs.markdown-oxide}/bin/markdown-oxide";
        ltex-ls.command = "${pkgs.ltex-ls}/bin/ltex-ls";
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
        indent-guides.render = true;
        indent-guides.character = "┊";
        indent-guides.skip-levels = 1;
        shell = [ "zsh" "-c" ];
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
        # bufferline = "multiple";
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
        select = { space = { q = ":reflow"; }; };
        insert = {
          C-c = "normal_mode";
          "C-[" = "normal_mode";
        };
      };
    };
  };
}
