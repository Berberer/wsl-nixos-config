{ inputs
, lib
, config
, pkgs
, ...
}: {

  nixpkgs = {
    hostPlatform = "x86_64-linux";

    config = {
      allowUnfree = true;
    };
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

  environment.systemPackages = with pkgs; [
    git
    home-manager
  ];

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

  wsl = {
    enable = true;
    defaultUser = "lukas";
    nativeSystemd = true;

    wslConf = {
      automount.root = "/mnt";
      user.default = "lukas";
      interop.appendWindowsPath = false;
    };
  };

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

  system.stateVersion = "23.11";
}
