{ config, lib, pkgs, ... }:

let
  cfg = config.my.gaming;
in
{
  options.my.gaming.enable =
    lib.mkEnableOption "gaming support";

  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = true;
      package = pkgs.millennium-steam;
    };

    programs.gamemode.enable = true;
  };
}
