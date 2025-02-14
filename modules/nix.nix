{ lib, ... }:
{
  nix.optimise.automatic = true;
  nix.settings = {
    trusted-users = [ "andreas" ];
    max-jobs = lib.mkDefault 60;
    experimental-features = "nix-command flakes";
  };
}
