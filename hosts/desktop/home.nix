{ config, pkgs, ... }:

{
  imports = [
    ../../modules/common-home.nix
  ];

  home.packages = with pkgs; [
    discord-ptb
  ];

  programs.mangohud = {
    enable = true;
    enableSessionWide = true;

    settings = {
      no_display = true;

      gpu_stats = true;
      gpu_temp = true;
      gpu_core_clock = true;

      cpu_stats = true;
      cpu_temp = true;

      vram = true;

      fps = true;
      frametime = true;

      vulkan_driver = true;
      wine = true;

      toggle_hud = "Shift_L+F12";
      toggle_fps_limit = "Shift_L+F1";

      vsync = 0;
      fps_limit = [
        60
        144
      ];
    };
  };
}
