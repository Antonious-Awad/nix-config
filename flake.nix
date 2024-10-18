{
  description = "Personal Nix configuration with GUI applications";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }: 
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };
    in
    {
      packages.${system} = {
        default = self.packages.${system}.myPackages;
        myPackages = pkgs.buildEnv {
          name = "my-packages";
          paths = with pkgs; [
            # GUI Applications
            # firefox
            # vscode
            # spotify
            discord
            # gimp
            # vlc
            
            # Terminal utilities
            # git
            # htop
            # ripgrep
            
            # Development tools
            # gcc
            # python3
          ];
          
          # Ensure XDG desktop integration
          extraOutputsToInstall = [ "bin" "man" "share" ];
        };
      };

      nixConfig = {
        experimental-features = [ "nix-command" "flakes" ];
        substituters = [
          "https://cache.nixos.org"
        ];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        ];
        auto-optimise-store = true;
        allowed-users = [ "@wheel" ];
      };
    };
}