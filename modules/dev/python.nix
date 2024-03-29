# modules/dev/python.nix --- https://godotengine.org/

{ config, options, lib, pkgs, my, ... }:

with lib;
with lib.my;
let cfg = config.modules.dev.python;
in {
  options.modules.dev.python = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      python39
      python39Packages.pip
      # python39Packages.ipython
      # python39Packages.black
      # python39Packages.setuptools
      # python39Packages.pylint
      # python39Packages.poetry
    ];

    env.IPYTHONDIR = "$XDG_CONFIG_HOME/ipython";
    env.PIP_CONFIG_FILE = "$XDG_CONFIG_HOME/pip/pip.conf";
    env.PIP_LOG_FILE = "$XDG_DATA_HOME/pip/log";
    env.PYLINTHOME = "$XDG_DATA_HOME/pylint";
    env.PYLINTRC = "$XDG_CONFIG_HOME/pylint/pylintrc";
    env.PYTHONSTARTUP = "$XDG_CONFIG_HOME/python/pythonrc";
    env.PYTHON_EGG_CACHE = "$XDG_CACHE_HOME/python-eggs";
    env.JUPYTER_CONFIG_DIR = "$XDG_CONFIG_HOME/jupyter";

    environment.shellAliases = {
      py = "python";
      py2 = "python2";
      py3 = "python3";
      # po = "poetry";
      # ipy = "ipython --no-banner";
      # ipylab = "ipython --pylab=qt5 --no-banner";
    };
  };
}
