{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.borgbackup;
in {
  options.modules.services.borgbackup = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    # services.borgbackup.enable = true;
    # services.borgbackup.jobs.home = {
    #   paths = "/home/${config.user.name}";
    #   encryption.mode = "none";
    #   # environment.BORG_RSH = "ssh -i /home/kei/.ssh/id_ed25519";
    #   # repo = "ssh://user@example.com:23/path/to/backups-dir/home";
    #   compression = "auto,zstd";
    #   startAt = "weekly";
    # };

    services.borgbackup.jobs = let
      common-excludes = [
        # Largest cache dirs
        ".cache"
        "*/cache2" # firefox
        "*/Cache"
        ".config/Slack/logs"
        ".config/Code/CachedData"
        ".container-diff"
        ".npm/_cacache"
        "*/node_modules"
      ];
      work-dirs = [
        # "/home/${config.user.name}/freshcode"
      ];
      basicBorgJob = name: {
        encryption.mode = "none";
        # environment.BORG_RSH = "ssh -o 'StrictHostKeyChecking=no' -i /home/danbst/.ssh/id_ed25519";
        # environment.BORG_UNKNOWN_UNENCRYPTED_REPO_ACCESS_IS_OK = "yes";
        extraCreateArgs = "--verbose --stats --checkpoint-interval 600";
        repo = "${config.user.home}/media/backups/${name}";
        compression = "zstd,1";
        startAt = "weekly";
        user = config.user.name;
      };
    in {
      home = basicBorgJob "station/home-${config.user.name}" // rec {
        paths = config.user.home;
        exclude = work-dirs ++ map (x: paths + "/" + x)
          (common-excludes ++ [ "vids" "Downloads" "games" "Games" "media" ]);
      };
    };
  };
}
