{ inputs
, ...
}: {

  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops = {
    age.keyFile = "/home/lukas/.config/sops/age/keys.txt";
    defaultSopsFile = ../../secrets/secrets.yaml;

    secrets = {
      id_rsa = {
        path = "/home/lukas/.ssh/id_rsa";
      };
      id_rsa_pub = {
        path = "/home/lukas/.ssh/id_rsa.pub";
      };
      nix_conf_include_access_tokens = { };
    };
  };

  systemd.user.services.mbsync.Unit.After = [ "sops-nix.service" ];

}
