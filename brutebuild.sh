sudo nixos-rebuild switch \
  --extra-experimental-features "nix-command flakes" \
  --flake .#caveos \
  --show-trace
