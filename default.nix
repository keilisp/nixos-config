# ; Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, ... }:

with lib;
with lib.my; {
  imports =
    # I use home-manager to deploy files to $HOME; little else
    [
      inputs.home-manager.nixosModules.home-manager
    ]
    # All my personal modules
    ++ (mapModulesRec' (toString ./modules) import);

  # Common config for all nixos machines; and to ensure the flake operates
  # soundly
  environment.variables.DOTFILES = config.dotfiles.dir;
  environment.variables.DOTFILES_BIN = config.dotfiles.binDir;

  # Configure nix and nixpkgs
  environment.variables.NIXPKGS_ALLOW_UNFREE = "1";
  nix = let
    filteredInputs = filterAttrs (n: _: n != "self") inputs;
    nixPathInputs = mapAttrsToList (n: v: "${n}=${v}") filteredInputs;
    registryInputs = mapAttrs (_: v: { flake = v; }) filteredInputs;
  in {
    package = pkgs.nixFlakes;
    extraOptions = lib.optionalString (config.nix.package == pkgs.nixFlakes)
      "experimental-features = nix-command flakes";
    nixPath = nixPathInputs ++ [
      "nixpkgs-overlays=${config.dotfiles.dir}/overlays"
      "dotfiles=${config.dotfiles.dir}"
    ];
    settings.substituters = [ "https://nix-community.cachix.org" ];
    # binaryCaches = [ "https://nix-community.cachix.org" ];
    settings.trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    # binaryCachePublicKeys = [
    #   "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    # ];
    registry = registryInputs // { dotfiles.flake = inputs.self; };
    settings.auto-optimise-store = true;
    # autoOptimiseStore = true;
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Use the latest kernel
  boot = {
    kernelPackages = mkDefault pkgs.linuxKernel.packages.linux_5_18;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    bind
    cached-nix-shell
    coreutils
    git
    vim
    wget
    gnumake
    unzip
  ];

  systemd.extraConfig = ''
    DefaultTimeoutStopSec=3s
    DefaultTimeoutStartSec=3s
  '';

  system.configurationRevision = with inputs; mkIf (self ? rev) self.rev;
  system.stateVersion = "22.05";

}

