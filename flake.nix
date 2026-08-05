{
  description = "My nixos setup for my thinkpad";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # Official Hyprland flake — deliberately does NOT follow nixpkgs so that
    # nixpkgs packaging breakage (e.g. the glaze FetchContent bug) can't break Hyprland.
    hyprland = {
      url = "github:hyprwm/Hyprland";
    };
    helium = {
      url = "github:FKouhai/helium2nix/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
	url = "github:noctalia-dev/noctalia";
	inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, helium, home-manager, noctalia, hyprland, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
     specialArgs = { inherit inputs; };

     modules = [ 
       ./configuration.nix
       ./hardware-configuration.nix 
	home-manager.nixosModules.home-manager
        {
         home-manager.useGlobalPkgs = true;
         home-manager.useUserPackages = true;
         home-manager.users.lu = import ./home.nix;
	 home-manager.extraSpecialArgs = { inherit inputs; };
        }
     ]; 
    };
  };
}
