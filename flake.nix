{
  description = "WSL NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    lix-module.url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.1-1.tar.gz";
    lix-module.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-wsl.url = "github:nix-community/nixos-wsl";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    vscode-server.url = "github:nix-community/nixos-vscode-server";
    vscode-server.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { self
    , nixpkgs
    , nixpkgs-unstable
    , lix-module
    , home-manager
    , nixos-wsl
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
            lix-module.nixosModules.default
            nixos-wsl.nixosModules.wsl
            ./configuration.nix
          ];
        };
      };

      homeConfigurations = {
        "lukas@wsl-nixos" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgsConfig;
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./home.nix
          ];
        };
      };
    };
}
