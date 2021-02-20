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

  services.syncthing.declarative = {
    devices = {
      ao.id = "2KCHVTE-RENXIJR-BGAMEK6-U7VMCI2-L5CCOBT-PCIZZER-EO6B2DQ-MZWSVQF";
      kuro.id =
        "L63W5ED-C2Z6EYZ-PRVOG5G-SYWYGGC-J7SVUW5-LTBO66J-IU5Q6P3-MXTV5QE";
      ako.id =
        "CBBDN3Q-6LYXCUZ-3R4V32E-VTM55JQ-PIMD4TM-SRYK2NN-D4RUCC5-4FHYWQG";
      shiro.id =
        "VA5JTJZ-W2XYWQT-OP5PHPA-WUKGVDL-DXF6DIK-K4IL4KB-SATM5ZR-JWO2LAO";
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
      sync = mkShare "personal_files" [ "kuro" "ao" "ako" "shiro" "aijiro" ]
        "sendreceive" "${config.user.home}/sync/personal_files";
    };
  };
}
