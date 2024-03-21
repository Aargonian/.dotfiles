{
  description = "Aaron's Personal Flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs:
    let
      lib = nixpkgs.lib;
      system = "aarch64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
      overlays = [
        inputs.neovim-nightly-overlay.overlay
      ];
      username = "aargonian";
      hostname = "NixosPersonal";

      # Primarily used for the develop shell for tauri
      libraries = with pkgs; [
        webkitgtk
        gtk3
        cairo
        gdk-pixbuf
        glib
        dbus
        openssl_3
        librsvg
      ];
      packages = with pkgs; [
        curl
        wget
        pkg-config
        dbus
        openssl_3
        glib
        gtk3
        libsoup
        webkitgtk
        librsvg
      ];
    in {

    nixosConfigurations = {
      ${hostname} = lib.nixosSystem {
        inherit system;
        modules = [ ./configuration.nix ];
        specialArgs = {
          inherit username;
          inherit hostname;
          inherit pkgs-unstable;
        };
      };
    };
    homeConfigurations = {
      ${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home.nix
          ({
            nixpkgs.overlays = overlays;
          })
        ];
        extraSpecialArgs = {
          inherit username;
          inherit pkgs-unstable;
        };
      };
    };
    devShells.${system}.default = pkgs.mkShell {
      buildInputs = packages;
      shellHook = ''
          export LD_LIBRARY_PATH=${lib.makeLibraryPath libraries}:$LD_LIBRARY_PATH
          export XDG_DATA_DIRS=${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}:$XDG_DATA_DIRS
      '';
    };
  };
}
