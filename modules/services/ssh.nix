{ options, config, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.ssh;
in {
  options.modules.services.ssh = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      challengeResponseAuthentication = false;
      passwordAuthentication = false;
    };

    user.openssh.authorizedKeys.keys = if config.user.name == "kei" then
      [
        # Ao
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH9FT7tVSrQnp1SM7JKVIGuY3fDprmiIhoNwr2nnGBG3 druksasha@ukr.net "
        # Kuro
      ]
    else
      [ ];
  };
}
