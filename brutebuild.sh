sudo env NIX_CONFIG="experimental-features = nix-command flakes" \
  nixos-rebuild switch \
  --flake .#caveos \
  --show-trace
