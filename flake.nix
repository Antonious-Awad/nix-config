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
          firefox.enableWayland = true;
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
              
              sessionVariables = {
                NIXOS_OZONE_WL = "1";
                MOZ_ENABLE_WAYLAND = "1";
                QT_QPA_PLATFORM = "wayland";
                GDK_BACKEND = "wayland";
              };
            };

            programs.home-manager.enable = true;

            # Configure Firefox as default browser
            programs.firefox = {
              enable = true;
              package = pkgs.firefox;
              profiles.default = {
                isDefault = true;
              };
            };

            # XDG configurations
            xdg = {
              enable = true;
              mime.enable = true;
              mimeApps = {
                enable = true;
                defaultApplications = {
                  "text/html" = ["firefox.desktop"];
                  "x-scheme-handler/http" = ["firefox.desktop"];
                  "x-scheme-handler/https" = ["firefox.desktop"];
                  "x-scheme-handler/chrome" = ["firefox.desktop"];
                  "application/x-extension-htm" = ["firefox.desktop"];
                  "application/x-extension-html" = ["firefox.desktop"];
                  "application/x-extension-shtml" = ["firefox.desktop"];
                  "application/xhtml+xml" = ["firefox.desktop"];
                  "application/x-extension-xhtml" = ["firefox.desktop"];
                  "application/x-extension-xht" = ["firefox.desktop"];
                };
              };
              
              # Explicitly create desktop entries
              desktopEntries = {
                discord = {
                  name = "Discord";
                  genericName = "Internet Messenger";
                  exec = "discord --enable-features=WaylandWindowDecorations --ozone-platform=wayland";
                  icon = "discord";
                  type = "Application";
                  categories = [ "Network" "InstantMessaging" ];
                  terminal = false;
                };
              };
            };

            # Nicely reload system units when changing configs
            systemd.user.startServices = "sd-switch";
          }
        ];
      };
    };
}