{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/common-configuration.nix
  ];

  networking.hostName = "raul-xps";
}
