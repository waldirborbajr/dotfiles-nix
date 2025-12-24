{ config, pkgs, ... }:

{
  imports = [
    ../../modules/nixos/default.nix
    ./hardware-configuration.nix
  ];

  #### Bootloader (OBRIGATÓRIO no host)
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = true;

  #### Host identity
  networking.hostName = "caveos";

  #### User
  users.users.borba = {
    isNormalUser = true;
    description = "BORBA JR W";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.11";
}
