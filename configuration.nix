{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./happ-nixos/happ-module.nix
      
#      ./modules/services/zapret.nix
      ./modules/services/happ.nix

      ./modules/keyring.nix
      ./modules/fonts.nix
      ./modules/graphics.nix
      ./modules/niri.nix
      ./modules/packages.nix
      ./modules/gaming.nix
      ./modules/networking.nix
      ./modules/localization.nix
      ./modules/boot.nix
      ./modules/desktop.nix
      ./modules/users.nix
      ./modules/polkit.nix
      ./modules/base.nix
      ./modules/overlays.nix
      ./modules/mime.nix
      ./modules/users.nix
    ];
}
