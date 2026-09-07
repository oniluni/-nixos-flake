{ pkgs, ... }:

{
  my.gaming.enable = true;
  
  programs.fish.enable = true;
  programs.xwayland.enable = true;

  programs.nix-ld = {
    enable = true;

    libraries = with pkgs; [
      libGL
      libGLU
    ];
  };

  services.greetd = {
    enable = true;

    settings = {
      initial_session = {
        command = "niri-session";
        user = "oni";
      };

      default_session = {
        command =
          "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd niri-session";
        user = "greeter";
      };
    };
  };
}