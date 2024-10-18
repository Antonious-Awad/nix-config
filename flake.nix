{
  description = "Home Manager Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          # firefox.enableWayland = true;
        };
      };
    in
    {
      homeConfigurations."tony" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        
        modules = [
          {
            home = {
              username = "tony";
              homeDirectory = "/home/tony";
              stateVersion = "23.11"; # Change this to your nixpkgs version
              
              packages = with pkgs; [
                # GUI Applications
                # firefox
                # vscode
                # spotify
                discord
                # gimp
                # vlc
                
                # Wayland utilities
                wl-clipboard
                xdg-utils
                
                # Terminal utilities
                # git
                # htop
                # ripgrep
                
                # Development tools
                # gcc
                # python3
              ];
              
              # Manage session variables
              sessionVariables = {
                NIXOS_OZONE_WL = "1";
                MOZ_ENABLE_WAYLAND = "1";
                QT_QPA_PLATFORM = "wayland";
                GDK_BACKEND = "wayland";
              };
            };

            # Enable Home Manager
            programs.home-manager.enable = true;

            # Configure git
            programs.git = {
              enable = true;
              userName = "tony";
              userEmail = "antonuostony1@gmail.com"; # Change this
            };

            # XDG MIME types and default applications
            xdg = {
              enable = true;
              mime.enable = true;
              mimeApps.enable = true;
            };

            # Nicely reload system units when changing configs
            systemd.user.startServices = "sd-switch";
          }
        ];
      };
    };
}