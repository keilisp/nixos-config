{ config, lib, ... }:

with lib; {
  networking.hosts = let
    hostConfig = {
      "192.168.1.2" = [ "ao" ];
      "192.168.1.3" = [ "kiiro" ];
      "192.168.1.10" = [ "kuro" ];
      "192.168.1.11" = [ "shiro" ];
      "192.168.1.12" = [ "midori" ];
    };
    hosts = flatten (attrValues hostConfig);
    hostName = config.networking.hostName;
  in mkIf (builtins.elem hostName hosts) hostConfig;

  time.timeZone = mkDefault "Europe/Kiev";
  i18n.defaultLocale = mkDefault "en_US.UTF-8";
  # For redshift, mainly
  location = {
    latitude = 49.5;
    longitude = 24.1;
  };

  ##
  # modules.shell.bitwarden.config.server = "p.v0.io";

  services.syncthing = {
    devices = {
      ao.id = "KQHX3S2-546W2K4-PYP2TAC-6IK4M2A-UD2NLOC-TWVNTUZ-ON3VGGE-EO6JHAS";
      kuro.id =
        "EMGO74L-WQ3YWSU-G2NZ6SZ-IG2CU2Z-SLODNKQ-EL42QP5-USZ6ZNB-T3IJDQM";
      ako.id =
        "CBBDN3Q-6LYXCUZ-3R4V32E-VTM55JQ-PIMD4TM-SRYK2NN-D4RUCC5-4FHYWQG";
      shiro.id =
        "DL3TBOC-35JFKDE-GSIOQWU-RLCEUIZ-YSPOGNG-KQYIJXM-4MZHYGR-6FMA5A3";
      aijiro.id =
        "MB3DXEU-TVUX53M-PYRNN2V-2VOB7VD-SW3E4K3-WV24KMA-URDHY25-4JBZLQL";

    };
    folders = let
      mkShare = name: devices: type: path: rec {
        inherit devices type path;
        watch = true;
        rescanInterval = 3600 * 4;
        # enabled = lib.elem config.networking.hostname devices;
      };
    in {
      org = mkShare "personal_files" [ "kuro" "ao" "ako" "shiro" "aijiro" ]
        "sendreceive" "${config.user.home}/org";

      passwrds = mkShare "personal_files" [ "kuro" "ao" "ako" "shiro" "aijiro" ]
        "sendreceive" "${config.user.home}/passwrds";

      dox = mkShare "dox" [ "kuro" "ao" "ako" "shiro" "aijiro" ] "sendreceive"
        "${config.user.home}/dox";

      unik = mkShare "unik" [ "kuro" "ao" "ako" "shiro" "aijiro" ] "sendreceive"
        "${config.user.home}/unik";
    };
  };
}
