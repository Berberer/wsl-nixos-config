{
  description = "WSL NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-wsl.url = "github:nix-community/nixos-wsl";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { self
    , nixpkgs
    , nixpkgs-unstable
    , home-manager
    , nixos-wsl
    , sops-nix
    , ...
    } @ inputs:
    let
      inherit (self) outputs;
      system = "x86_64-linux";

      nixpkgsConfig = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = _: true;
        };
        overlays = [
          (_final: prev: {
            unstable = import nixpkgs-unstable {
              inherit (prev) system;
              inherit (prev) config;
            };
          })
        ];
      };
    in
    {
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixpkgs-fmt;
      nixosConfigurations = {
        wsl-nixos = nixpkgs.lib.nixosSystem {
          pkgs = nixpkgsConfig;
          specialArgs = { inherit inputs outputs; };
          modules = [
            nixos-wsl.nixosModules.wsl
            sops-nix.nixosModules.sops
            ./configuration.nix
          ];
        };
      };

      homeConfigurations = {
        "lukas@wsl-nixos" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgsConfig;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            sops-nix.homeManagerModules.sops
            ./home.nix
          ];
        };
      };
    };
}
