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

    user.openssh.authorizedKeys.keys = if config.user.name == "kei" then [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJq23EnlbR2Q1lcClwnPylX5Dgw+dtpQhVlT4PLjDWnI druksasha@ukr.net"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINb/CqSUgRiZovS5a2CqtixJU4jgL7MbWrRxF3tOXjs6 druksasha@ukr.net "
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJOiIlqjp+a1XKmSq1nzrJxrI0HEacUm6d2qrvdfvZp3 druksasha@ukr.net"
    ] else
      [ ];
  };
}
