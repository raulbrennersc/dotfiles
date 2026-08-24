{ config, pkgs, ... }:

{
  imports = [ 
    ./hardware-configuration.nix 
    ../../modules/common-configuration.nix 
  ];

  networking.hostName = "raul-desktop";

  services.xserver.videoDrivers = ["amdgpu"];
  hardware.xpadneo.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; 
    dedicatedServer.openFirewall = true;
  };
  hardware.steam-hardware.enable = true;
  hardware.graphics.enable32Bit = true;
}
