{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];
  nixpkgs.config.allowUnfree = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;
  networking.hostName = "raul-desktop";
  networking.wireless.enable = false;
  networking.wireless.iwd.enable = true;
  networking.networkmanager.wifi.backend = "iwd";
  networking.networkmanager.dns = "systemd-resolved";
  networking.nameservers = [
    "1.1.1.1"
    "1.0.0.1"
    "2606:4700:4700::1111"
    "2606:4700:4700::1001"
  ];

  services.resolved = {
    enable = true;
    fallbackDns = [
      "1.1.1.1#one.one.one.one"
      "1.0.0.1#one.one.one.one"
      "2606:4700:4700::1111#one.one.one.one"
      "2606:4700:4700::1001#one.one.one.one"
    ];
    dnsovertls = "true";
    dnssec = "true";
    domains = [ "~." ];
  }; 

  services.resolved.enable = true;
  services.openssh.enable = true;
  services.udev.packages = with pkgs; [
    logitech-udev-rules
    bazecor
  ];

  hardware.i2c.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.xpadneo.enable = true;
  hardware.steam-hardware.enable = true;
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  hardware.logitech.wireless.enable = true;
  hardware.logitech.wireless.enableGraphical = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
  services.playerctld.enable = true;
  services.power-profiles-daemon.enable = true;
  services.udisks2.enable = true;

  services.udev.extraRules = ''
    # Grant the 'input' group access to uinput for Solaar on Wayland
    KERNEL=="uinput", GROUP="input", MODE="0660", OPTIONS+="static_node=uinput"
  '';

  services.xserver.videoDrivers = ["amdgpu"];

  services.displayManager.sddm = {
    enable = true;
    wayland = {
      enable = true;
    };
  };

  programs.uwsm.enable = true;
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };


  programs.fuse.userAllowOther = true;
  virtualisation.docker.enable = true;

  users.users.raul = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" "i2c" "input" "dialout"];
    shell = pkgs.bash;
  };

  environment.systemPackages = with pkgs; [
    git
    curl
    vim
    polkit_gnome
    pulseaudio
    solaar
    playerctl
    appimage-run
    bazecor
    discord-ptb
  ];

  programs.gpu-screen-recorder.enable = true;

  fonts.packages = with pkgs; [
    jetbrains-mono
    nerd-fonts.jetbrains-mono
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
  ];

  security.polkit.enable = true;

  fileSystems."/mnt/media" = {
    device = "/dev/disk/by-label/media";
    fsType = "ext4";
    options = [ "nofail" "defaults" ]; 
  };

  systemd.tmpfiles.rules = [
    "d /mnt/media 0755 raul users -"
  ];

  time.timeZone = "America/Sao_Paulo";

  system.stateVersion = "24.05";
}
