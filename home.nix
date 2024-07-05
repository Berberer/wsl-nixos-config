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
    };

    starship = {
      enable = true;
      settings = {
        add_newline = true;
        palette = "default";
        fill.symbol = " ";

        format = ''
          ╭─[](fg:background_blue)$os$username$hostname$localip$directory[](fg:background_blue) $git_branch$git_commit$git_state$git_metrics$git_status$docker_context$nix_shell$direnv$env_var$sudo$container$shell$fill$status$character$cmd_duration$time
          ╰╴[❯ ](fg:white)
        '';

        os = {
          disabled = false;
          style = "fg:white bg:background_blue";
          format = "[$symbol ]($style)";
          symbols.NixOS = " ";
        };

        username = {
          style_root = "fg:red bg:background_blue";
          style_user = "fg:white bg:background_blue";
          format = "[$user]($style)[ in ](fg:white bg:background_blue)";
        };

        hostname = {
          style = "fg:white bg:background_blue";
        };

        localip = {
          style = "fg:white bg:background_blue";
        };

        directory = {
          style = "fg:white bg:background_blue";
          read_only_style = "fg:white bg:background_blue";
          format = "[$path]($style)[$read_only]($read_only_style)";
          home_symbol = " ";
          read_only = " ";
          truncation_length = 3;
          truncation_symbol = "…/";
        };

        git_branch = {
          style = "bold fg:white bg:background_orange";
          format = "on [](fg:background_orange)[$symbol$branch(:$remote_branch) ]($style)";
        };

        git_commit = {
          style = "bold fg:white bg:background_orange";
          format = "[\($hash$tag\) ]($style)";
        };

        git_state = {
          style = "bold fg:white bg:background_orange";
          format = "\([$state( $progress_current/$progress_total) ]($style)\)";
        };

        git_metrics = {
          disabled = false;
          added_style = "bold fg:green bg:background_orange";
          deleted_style = "bold fg:red bg:background_orange";
          format = "[([+$added]($added_style) [-$deleted]($deleted_style) )](bg:background_orange)";
        };

        git_status = {
          style = "bold fg:white bg:background_orange";
          format = "[(\\[$all_status$ahead_behind\\])]($style)[](fg:background_orange)";
          diverged = " ⇕⇡$ahead_count⇣$behind_count ";
          ahead = " ⇡$count ";
          behind = " ⇣$count ";
          staged = " 󱝿 $count ";
          untracked = " 󰎜 $count ";
          modified = " 󱞁 $count ";
          conflicted = " 󱝽 $count ";
          deleted = " 󱙑 $count";
          stashed = "  $count ";
        };

        character = {
          success_symbol = "[](bold green)";
          error_symbol = "[](bold red)";
        };

        time = {
          disabled = false;
        };

        palettes.default = {
          background_blue = "#00497a";
          background_orange = "#b37014";
        };
      };
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
