{ config, pkgs, inputs, ... }:

{
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
    ./home/modules/spicetify.nix
  ];

  home.username = "oni";
  home.homeDirectory = "/home/oni";
  home.stateVersion = "26.05";

  home.sessionVariables.XCURSOR_SIZE = "16";

  programs.home-manager.enable = true;
}
