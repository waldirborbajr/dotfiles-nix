sudo env NIX_CONFIG="experimental-features = nix-command flakes" \
  nixos-rebuild switch \
  --flake /home/borba/dotfiles-nix#caveos \
  --show-trace
