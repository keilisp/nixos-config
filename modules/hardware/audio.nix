{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.hardware.audio;
in {
  options.modules.hardware.audio = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {

    user.packages = with pkgs; [ alsa-utils ];

    hardware.pulseaudio.enable = false;
    # rtkit is optional but recommended
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true; # if not already enabled
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;
    };

    # Music daemon, can be accessed through mpc or an other client
    services.mpd = {
      enable = true;
    };

    # HACK Prevents ~/.esd_auth files by disabling the esound protocol module
    #      for pulseaudio, which I likely don't need. Is there a better way?
    # hardware.pulseaudio.configFile = let
    #   inherit (pkgs) runCommand pulseaudio;
    #   paConfigFile = runCommand "disablePulseaudioEsoundModule" {
    #     buildInputs = [ pulseaudio ];
    #   } ''
    #     mkdir "$out"
    #     cp ${pulseaudio}/etc/pulse/default.pa "$out/default.pa"
    #     sed -i -e 's|load-module module-esound-protocol-unix|# ...|' "$out/default.pa"
    #   '';
    # in mkIf config.hardware.pulseaudio.enable "${paConfigFile}/default.pa";

    user.extraGroups = [ "audio" ];
  };
}
