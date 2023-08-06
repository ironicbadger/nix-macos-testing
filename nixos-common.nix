{ pkgs, lib, inputs, ... }:
let 
  inherit (inputs) nixpkgs nixpkgs-unstable;
in 
in
{
  time.timeZone = "America/New_York";

  nix = {
    settings = {
        experimental-features = [ "nix-command" "flakes" ];
        warn-dirty = false;
    };
    # Automate garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
  
  # pins to stable as unstable updates very often
  # nix.registry.nixpkgs.flake = inputs.nixpkgs;
  # nix.registry = {
  #   n.to = {
  #     type = "path";
  #     path = inputs.nixpkgs;
  #   };
  #   u.to = {
  #     type = "path";
  #     path = inputs.nixpkgs-unstable;
  #   };
  # };
}