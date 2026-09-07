{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    millennium.url =
      "git+https://github.com/SteamClientHomebrew/Millennium?dir=packages/nix";

    spicetify-nix.url =
      "github:Gerg-L/spicetify-nix";

    noctalia.url =
      "github:noctalia-dev/noctalia-shell";

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zapret-rust.url =
      "github:Sergeydigl3/zapret-discord-youtube-rust";
  };

  outputs = inputs@{
    self,
    nixpkgs,
    home-manager,
    noctalia,
    zen-browser,
    zapret-rust,
    millennium,
    ...
  }: {
    nixosConfigurations.oni = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      specialArgs = {
        inherit inputs;
      };

      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager

        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.extraSpecialArgs = {
            inherit inputs;
          };
          home-manager.users.oni = import ./home.nix;
        }
      ];
    };
  };
}
