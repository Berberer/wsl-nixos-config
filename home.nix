{ config
, pkgs
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

  unstable-packages = with pkgs.unstable ; [
    oh-my-posh
  ];
in
{

  sops = {
    age.keyFile = "/home/lukas/.config/sops/age/keys.txt";
    defaultSopsFile = ./secrets/secrets.yaml;

    secrets = {
      id_rsa = {
        path = "/home/lukas/.ssh/id_rsa";
      };
      id_rsa_pub = {
        path = "/home/lukas/.ssh/id_rsa.pub";
      };
      nix_conf = {
        path = "/home/lukas/.config/nix/nix.conf";
      };
    };
  };

  home.activation.setupEtc = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    /run/current-system/sw/bin/systemctl start --user sops-nix.service
  '';

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
      bashrcExtra = ''
        eval "$(oh-my-posh init bash --config ${pkgs.unstable.oh-my-posh}/share/oh-my-posh/themes/emodipt-extend.omp.json)"
      '';
    };

    direnv = {
      enable = true;
      enableBashIntegration = true; # see note on other shells below
      nix-direnv.enable = true;
    };

    git = {
      enable = true;
      package = pkgs.git;
      lfs.enable = true;
      delta.enable = true;
      delta.options = {
        line-numbers = true;
        side-by-side = true;
        navigate = true;
      };
      extraConfig = {
        init = {
          defaultBranch = "main";
        };
        push = {
          default = "current";
          autoSetupRemote = true;
        };
        merge = {
          conflictstyle = "diff3";
        };
        diff = {
          colorMoved = "default";
        };
      };
    };
  };

}
