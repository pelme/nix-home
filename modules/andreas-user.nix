{
  config,
  lib,
  ...
}:
{
  users.users.andreas = {
    isNormalUser = true;
    description = "Andreas Pelme";
    extraGroups = (
      [ "wheel" ] ++ lib.optional config.networking.networkmanager.enable "networkmanager"
    );
  };
}
