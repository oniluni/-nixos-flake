{ pkgs, ... }:

{
  users.users.oni = {
    isNormalUser = true;
    description = "oni";
    shell = pkgs.fish;

    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };
  
}