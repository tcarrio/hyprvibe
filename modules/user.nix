# This module solely serves to provide a common option to reference for
# the preferred username on the system.
# For example, this will dynamically set the target for HOME operations.
{ lib, pkgs, config, ... }: {
  options.hyprvibe.user = {
    username = lib.mkOption {
      type = lib.types.string;
      default = "chrisf";
      description = "The primary user's name in NixOS";
    };
  };
}


