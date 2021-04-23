{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.hardware.audio;
in {
  options.modules.hardware.audio = { enable = mkBoolOpt true; };

  config = mkIf cfg.enable {
    sound.enable = true;
    hardware.pulseaudio = {
      enable = true;
      extraConfig =
        "load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1"; # Needed by mpd to be able to use Pulseaudio
    };

    services.mpd = {
      enable = true;
      extraConfig = ''
        audio_output {
          type "pulse" # MPD must use Pulseaudio
          name "Pulseaudio" # Whatever you want
          server "127.0.0.1" # MPD must connect to the local sound server
        }
      '';
      startWhenNeeded = true;
    };

    # HACK Prevents ~/.esd_auth files by disabling the esound protocol module
    #      for pulseaudio, which I likely don't need. Is there a better way?
    hardware.pulseaudio.configFile = let
      inherit (pkgs) runCommand pulseaudio;
      paConfigFile = runCommand "disablePulseaudioEsoundModule" {
        buildInputs = [ pulseaudio ];
      } ''
        mkdir "$out"
        cp ${pulseaudio}/etc/pulse/default.pa "$out/default.pa"
        sed -i -e 's|load-module module-esound-protocol-unix|# ...|' "$out/default.pa"
      '';
    in mkIf config.hardware.pulseaudio.enable "${paConfigFile}/default.pa";

    user.extraGroups = [ "audio" "mpd" ];
  };
}
