{ lib, pkgs, config, ... }:
let
  cfg = config.hyprvibe.shell;
  inherit (config.hyprvibe.user) username;
in {
  options.hyprvibe.shell = {
    enable = lib.mkEnableOption "Fish + Oh My Posh + Atuin basics";
    kittyAsDefault = lib.mkEnableOption "Set kitty as default terminal and env";
    ohMyPoshDefault = lib.mkOption {
      type = lib.types.lines;
      default = ''{"$schema":"https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json","version":1,"final_space":true,"blocks":[]}'';
      description = "Default OMP config JSON when user config is missing";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.fish.enable = true;
    environment.systemPackages = [ pkgs.oh-my-posh ];

    system.activationScripts.shell = lib.mkAfter ''
      mkdir -p /home/${username}/.config/fish/conf.d
      cat > /home/${username}/.config/fish/conf.d/oh-my-posh.fish << 'EOF'
      if command -q oh-my-posh
        oh-my-posh init fish --config ~/.config/oh-my-posh/config.json | source
      end
      EOF
      # Ensure ~/.local/bin is on PATH
      cat > /home/${username}/.config/fish/conf.d/local-bin.fish << 'EOF'
      if test -d "$HOME/.local/bin"
        fish_add_path "$HOME/.local/bin"
      end
      EOF
      mkdir -p /home/${username}/.config/oh-my-posh
      # Only create default config if no config.json exists (preserve user configs)
      if [ ! -f /home/${username}/.config/oh-my-posh/config.json ]; then
        echo '${cfg.ohMyPoshDefault}' > /home/${username}/.config/oh-my-posh/config-default.json
        cp /home/${username}/.config/oh-my-posh/config-default.json /home/${username}/.config/oh-my-posh/config.json
      fi
      chown -R ${username}:users /home/${username}/.config/fish /home/${username}/.config/oh-my-posh
    '';

    environment.sessionVariables = lib.mkIf cfg.kittyAsDefault {
      TERMINAL = "kitty";
      KITTY_CONFIG_DIRECTORY = "~/.config/kitty";
      KITTY_SHELL_INTEGRATION = "enabled";
    };
  };
}


