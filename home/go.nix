{ pkgs, config, ... }:
{

  programs.go = {
    enable = true;
    telemetry = {
      mode = "off";
    };
  };

  home.packages = with pkgs; [

# Go debugger
    delve
# Language server
    gopls
# Formatting
    golines
# Formatting (goimports)
    gotools
# Linting
    golangci-lint
    golangci-lint-langserver

    air
    go-outline
    go-symbols
    gocode-gomod
    godef
    gofumpt
    gomodifytags
    gopkgs
    goreleaser
    gotests
    iferr
    impl
    revive
    sqlc
    templ 
  ];

  home.sessionVariables = {
    GOPATH = "$HOME/go";
    # GOBIN = "${GOPATH}/bin";
    GOBIN = "$HOME/go/bin";

  #   GOROOT = "${config.programs.go.package}/share/go";
  #   GOPATH = "${config.home.homeDirectory}/go";
  #   GOBIN = "${config.home.homeDirectory}/bin";
  };

  home.sessionPath = [ "${config.home.sessionVariables.GOBIN}" ];
}
