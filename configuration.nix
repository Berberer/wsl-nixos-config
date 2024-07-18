{ pkgs
, ...
}:
let
  stable-packages = with pkgs; [
    git
    wget
    nano
    home-manager
  ];

  unstable-packages = with pkgs.unstable ; [
    nix-ld-rs
  ];
in
{

  imports = [
    ./modules/system/wsl.nix
  ];

  nixpkgs = {
    hostPlatform = "x86_64-linux";
  };

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };

    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };

  environment.systemPackages = stable-packages ++ unstable-packages;

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune.enable = true;
  };

  time.timeZone = "Europe/Berlin";
  console.keyMap = "us";
  i18n = {
    defaultLocale = "C.UTF-8";
  };

  security.sudo = {
    execWheelOnly = true;
    wheelNeedsPassword = true;
  };

  networking.hostName = "wsl-nixos";

  users.mutableUsers = false;
  users.users.lukas = {
    isNormalUser = true;
    home = "/home/lukas";
    hashedPassword = "$6$H.zOZbASVsDegPRO$GZ66d5UP1V7xYJDyKslfNkLJuWs973duBBUv8/g4.FwCGcHxMwBZ7OEUK7eBme2anNWv5cDdtETX2o2KE7KMN1";
    shell = pkgs.bashInteractive;
    extraGroups = [
      "wheel"
      "docker"
    ];
  };

  systemd = {
    services = {
      "serial-getty@ttyS0".enable = false;
      "serial-getty@hvc0".enable = false;
      "getty@tty1".enable = false;
      "autovt@".enable = false;

      firewall.enable = false;
      systemd-resolved.enable = false;
      systemd-udevd.enable = false;
    };

    enableEmergencyMode = false;
  };

  programs.nix-ld = {
    enable = true;
    libraries = [ pkgs.stdenv.cc.cc ];
    package = pkgs.unstable.nix-ld-rs;
  };

  system.stateVersion = "23.11";
}
