{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    rust-analyzer
    rustfmt
    cargo

    gopls
    go_1_25
    goperf
    golangci-lint
    golangci-lint-langserver
    delve

    nil
    nixd
    alejandra
  ];

  programs.helix = {
    enable = true;
    defaultEditor = true;

    settings = {
      theme = "solarized_dark";
      editor = {
        line-number = "relative";
        lsp.display-messages = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
      };
    };

    themes.solarized_dark = {
      inherits = "solarized_dark";
      "ui.background" = { };
      "ui.statusline" = { };
      "ui.gutter" = { };
    };

    languages.language = [
      {
        name = "go";
        roots = [
          "go.work"
          "go.mod"
        ];
        auto-format = true;
        formatter.command = "gofmt";
        language-servers = [
          "gopls"
          "golangci-lint-lsp"
        ];
      }
      {
        name = "rust";
        auto-format = true;
        formatter = {
          command = "rustfmt";
          args = [
            "--edition"
            "2021"
          ];
        };
        language-servers = [ "rust-analyzer" ];
      }
      {
        name = "nix";
        formatter = {
          command = lib.getExe pkgs.nixfmt-rfc-style;
        };
        auto-format = true;
      }
    ];

    languages.language-server.golangci-lint-lsp = {
      command = "golangci-lint-langserver";
      config.command = [
        "golangci-lint"
        "run"
        "--path-mode=abs"
        "--output.json.path=stdout"
        "--output.text.path=/dev/null"
        "--show-stats=false"
        "--issues-exit-code=1"
      ];
    };

    # Surface Go escape analysis / GC hints inline via gopls.
    languages.language-server.gopls.config = {
      "ui.codelenses" = {
        gc_details = true;
      };
      "ui.diagnostic.annotations" = {
        escape = true;
        inline = true;
      };
    };

    languages.language-server.rust-analyzer.config = {
      checkOnSave.command = "clippy";
      cargo.allFeatures = true;
    };

  };
}
