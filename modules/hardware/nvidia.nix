{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.hardware.nvidia;
  isKon = config.networking.hostName == "kon";
in {
  options.modules.hardware.nvidia = { enable = mkBoolOpt false; };

  config = mkMerge [
    (mkIf (cfg.enable && isKon) {

      specialisation = {
        on-the-go.configuration = {
          system.nixos.tags = [ "on-the-go" ];
          hardware.nvidia = {
            prime.offload.enable = lib.mkForce true;
            prime.offload.enableOffloadCmd = lib.mkForce true;
            prime.sync.enable = lib.mkForce false;
          };
        };

        docked.configuration = {
          system.nixos.tags = [ "docked" ];
          hardware.nvidia = {
            prime.offload.enable = lib.mkForce false;
            prime.offload.enableOffloadCmd = lib.mkForce false;
            prime.sync.enable = lib.mkForce true;
          };
        };
      };

      environment.systemPackages = with pkgs; [ lshw ];

      # Enable OpenGL
      hardware.graphics = { enable = true; };

      # Load nvidia driver for Xorg and Wayland
      services.xserver.videoDrivers = [ "nvidia" ];

      hardware.nvidia = {

        # Modesetting is required.
        modesetting.enable = true;

        # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
        # Enable this if you have graphical corruption issues or application crashes after waking
        # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
        # of just the bare essentials.
        powerManagement.enable = false;

        # Fine-grained power management. Turns off GPU when not in use.
        # Experimental and only works on modern Nvidia GPUs (Turing or newer).
        powerManagement.finegrained = false;

        # Use the NVidia open source kernel module (not to be confused with the
        # independent third-party "nouveau" open source driver).
        # Support is limited to the Turing and later architectures. Full list of 
        # supported GPUs is at: 
        # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
        # Only available from driver 515.43.04+
        # Currently alpha-quality/buggy, so false is currently the recommended setting.
        open = false;

        # Enable the Nvidia settings menu,
        # accessible via `nvidia-settings`.
        nvidiaSettings = true;

        # Optionally, you may need to select the appropriate driver version for your specific GPU.
        # package = config.boot.kernelPackages.nvidiaPackages.stable;
        package = config.boot.kernelPackages.nvidiaPackages.stable;

        prime = {
          offload = {
            enable = false;
            enableOffloadCmd = false;
          };

          sync.enable = true;

          nvidiaBusId = "PCI:1:0:0";
          amdgpuBusId = "PCI:5:0:0";

        };
      };

    })

    (mkIf (cfg.enable && !isKon) {

      hardware.graphics.enable = true;

      services.xserver.videoDrivers = [ "nvidia" ];

      environment.systemPackages = with pkgs; [
        linuxKernel.packages.linux_6_6.nvidia_x11
        # Respect XDG conventions, damn it!
        (writeScriptBin "nvidia-settings" ''
              #!${stdenv.shell}
          #     mkdir -p "$XDG_CONFIG_HOME/nvidia"
              exec ${config.boot.kernelPackages.nvidia_x11.settings}/bin/nvidia-settings --config="$XDG_CONFIG_HOME/nvidia/settings"
        '')
      ];
    })
  ];
}
