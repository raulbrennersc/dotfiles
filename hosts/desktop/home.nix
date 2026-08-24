{ config, pkgs, ... }:

{
  imports = [
    ../../modules/common-home.nix
  ];

  home.packages = with pkgs; [
    discord-ptb
  ];

  xdg.configFile = {
    "MangoHud".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/configs/MangoHud";
  };

  home.sessionVariables = {
    MANGOHUD = 1;
  };
}
