{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    # musnix.url = "github:musnix/musnix";
    # musnix.inputs.nixpkgs.follows = "nixpkgs";
    # companion.url = "github:noblepayne/bitfocus-companion-flake";
    # companion.inputs.nixpkgs.follows = "nixpkgs";

    prettyswitch.url = "github:noblepayne/pretty-switch";
    prettyswitch.inputs.nixpkgs.follows = "nixpkgs";
    
    hyprland.url = "github:hyprwm/Hyprland";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, prettyswitch, hyprland, ... }: {
    # Formatter (optional)
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;

    # NixOS modules that can be referenced by importing this flake
    nixosModules = {
      default = import ./modules;
      packages = import ./modules/packages.nix;
      desktop = import ./modules/desktop.nix;
      hyprland = import ./modules/hyprland.nix;
      waybar = import ./modules/waybar.nix;
      shell = import ./modules/shell.nix;
      services = import ./modules/services.nix;
    };

    nixosConfigurations = {
      rvbee = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/rvbee/system.nix
          prettyswitch.nixosModules.default
        ];
        specialArgs = {
          inherit hyprland;
        };
            };
      nixstation = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/nixstation/system.nix
          prettyswitch.nixosModules.default
        ];
        specialArgs = {
          inherit hyprland;
        };
      };
    };
  };
}
