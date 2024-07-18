{ pkgs
, ...
}: {

  programs.git = {
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

}
