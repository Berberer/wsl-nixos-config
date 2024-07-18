{ pkgs
, ...
}: {

  wsl = {
    enable = true;
    defaultUser = "lukas";
    nativeSystemd = true;
    interop.register = true;

    wslConf = {
      automount.root = "/mnt";
      user.default = "lukas";
    };

    extraBin = [
      { src = "${pkgs.coreutils}/bin/dirname"; }
      { src = "${pkgs.coreutils}/bin/readlink"; }
      { src = "${pkgs.coreutils}/bin/uname"; }
    ];
  };

}
