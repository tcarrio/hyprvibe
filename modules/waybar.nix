{ lib, pkgs, config, ... }:
let
  cfg = config.hyprvibe.waybar;
  inherit (config.hyprvibe.user) username;  
in {
  options.hyprvibe.waybar = {
    enable = lib.mkEnableOption "Waybar setup and config install";
    configPath = lib.mkOption { type = lib.types.nullOr lib.types.path; default = null; };
    stylePath = lib.mkOption { type = lib.types.nullOr lib.types.path; default = null; };
    scriptsDir = lib.mkOption { type = lib.types.nullOr lib.types.path; default = null; };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.waybar ];
    system.activationScripts.waybar = lib.mkAfter ''
      mkdir -p /home/${username}/.config/waybar/scripts
      # Remove existing files/symlinks before creating new ones
      rm -f /home/${username}/.config/waybar/config
      rm -f /home/${username}/.config/waybar/style.css
      ${lib.optionalString (cfg.configPath != null) ''ln -sf ${cfg.configPath} /home/${username}/.config/waybar/config''}
      ${lib.optionalString (cfg.stylePath != null) ''ln -sf ${cfg.stylePath} /home/${username}/.config/waybar/style.css''}
      ${lib.optionalString (cfg.scriptsDir != null) ''cp -f ${cfg.scriptsDir}/* /home/${username}/.config/waybar/scripts/ 2>/dev/null || true''}
      chown -R ${username}:users /home/${username}/.config/waybar
    '';
  };
}


