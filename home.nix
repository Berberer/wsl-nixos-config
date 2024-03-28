{ config
, pkgs
, ...
}:
let
  stable-packages = with pkgs; [
    git
    gnused
    which
    htop
    tree
    unzip
    zip
    nano
    just
    wget
    statix
    wsl-open
    clang
    python3
    poetry

    (fenix.complete.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
    ])
  ];

  unstable-packages = with pkgs.unstable ; [ ];
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

    file = {
      ".config/pypoetry/config.toml".text = ''
        virtualenvs.create = true
        virtualenvs.in-project = true
      '';
    };

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
