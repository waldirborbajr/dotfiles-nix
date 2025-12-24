{ config, pkgs, ... }:

{
  imports = [
    ../../modules/nixos/base.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "caveos";

  users.users.borba = {
    isNormalUser = true;
    description = "BORBA JR W";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.11";
}
