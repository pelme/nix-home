{lib, ...}: {
  nix.settings = {
    trusted-users = ["andreas"];
    max-jobs = lib.mkDefault 60;
    auto-optimise-store = true;
    experimental-features = "nix-command flakes";
  };
}
