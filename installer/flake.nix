{
  description = "Custom NixOS installer with multiple configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-generators, ... }: {
    packages.x86_64-linux = {
      # Generate custom ISO
      installer-iso = nixos-generators.nixosGenerate {
        system = "x86_64-linux";
        format = "install-iso";
        
        modules = [
          ./installer-config.nix
        ];
      };
    };
  };
}