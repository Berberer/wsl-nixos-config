{ pkgs
, ...
}:
let
  stable-packages = with pkgs; [
    tree
    unzip
    zip
    just
    statix
    wsl-open
  ];

  unstable-packages = with pkgs.unstable ; [ ];
in
{

  imports = [
    ./modules/home/sops.nix
    ./modules/home/git.nix
    ./modules/home/starship.nix
  ];

  home = {
    username = "lukas";
    homeDirectory = "/home/lukas";

    sessionVariables.EDITOR = "nano";

    packages = stable-packages ++ unstable-packages;

    stateVersion = "23.11";
  };

  programs = {
    home-manager.enable = true;

    htop.enable = true;

    ssh = {
      enable = true;
    };

    readline = {
      enable = true;
      variables = {
        completion-ignore-case = true;
      };
    };

    bash = {
      enable = true;
    };

    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };
  };

  services.vscode-server.enable = true;

}
