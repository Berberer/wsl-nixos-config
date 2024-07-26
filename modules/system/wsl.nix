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
  };

}
