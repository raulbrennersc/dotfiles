{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];
  nixpkgs.config.allowUnfree = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;
  services.resolved.enable = true;
  services.openssh.enable = true;

  hardware.i2c.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.xpadneo.enable = true;
  hardware.steam-hardware.enable = true;

  services.power-profiles-daemon.enable = true;
  services.udisks2.enable = true;

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  programs.uwsm.enable = true;
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  virtualisation.docker.enable = true;

  users.users.raul = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" "i2c" ];
    shell = pkgs.bash;
  };

  environment.systemPackages = with pkgs; [
    git
    curl
    vim
    polkit_gnome
  ];

  programs.gpu-screen-recorder.enable = true;

  fonts.packages = with pkgs; [
    jetbrains-mono
    nerd-fonts.jetbrains-mono
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];

  system.stateVersion = "24.05";
}
