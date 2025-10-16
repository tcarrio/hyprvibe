{ lib, pkgs, config, ... }:
let
  cfg = config.hyprvibe.hyprland;
  inherit (config.hyprvibe.user) username;
in {
  options.hyprvibe.hyprland = {
    enable = lib.mkEnableOption "Hyprland base setup";
    waybar.enable = lib.mkEnableOption "Waybar autostart integration";
    monitorsFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Per-host Hyprland monitors config file path";
    };
    wallpaper = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Wallpaper file path for hyprpaper/hyprlock generation";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    # Install base config; host supplies monitor file separately
    system.activationScripts.hyprlandBase = lib.mkAfter ''
      mkdir -p /home/${username}/.config/hypr
      # Remove existing symlinks/files if they exist
      rm -f /home/${username}/.config/hypr/hyprland-base.conf
      ln -sf ${../../configs/hyprland-base.conf} /home/${username}/.config/hypr/hyprland-base.conf
      ${lib.optionalString (cfg.monitorsFile != null) ''
        rm -f /home/${username}/.config/hypr/$(basename ${cfg.monitorsFile})
        ln -sf ${cfg.monitorsFile} /home/${username}/.config/hypr/$(basename ${cfg.monitorsFile})
      ''}
      chown -R ${username}:users /home/${username}/.config/hypr
    '';
  };
}


