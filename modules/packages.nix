{ pkgs, inputs, ... }:

let
  otter-launcher =
    pkgs.callPackage ../packages/otter-launcher.nix { };

  tg-ws-proxy =
    pkgs.callPackage ../packages/tg-ws-proxy.nix { };
in
{
  environment.systemPackages =
    (with pkgs; [
      libreoffice
      chafa
      fsel
      fzf
      neovim
      yazi
      spotify
      prismlauncher
      gamemode
      vscode
      vesktop
      xwayland-satellite
      unzip
      qimgv
      fastfetch
      curl
      kitty
      git
      rofi
      nftables
      telegram-desktop
      fish
      nautilus
    ])
    ++ [
      otter-launcher
      tg-ws-proxy

      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
      inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
}
