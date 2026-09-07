{ config, pkgs, ... }:

{
  programs.niri.enable = true;

  services.displayManager.defaultSession = "niri";

  systemd.user.services.niri.enableDefaultPath = false;
}
