{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/common-configuration.nix
  ];

  networking.hostName = "raul-desktop";

  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.xpadneo.enable = true;
  hardware.steam-hardware.enable = true;
  hardware.graphics.enable32Bit = true;

  programs.steam = {
    enable = true;
    extraCompatPackages = [ pkgs.proton-ge-bin ];
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
}
