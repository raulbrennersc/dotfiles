{ pkgs, ... }:

{
  imports = [
    ../../modules/common-home.nix
    ./gnome.nix
  ];

  home.packages = with pkgs; [
    google-chrome
    slack
    junction
  ];

  home.sessionVariables = {
    DEFAULT_BROWSER = "${pkgs.junction}/bin/junction";
  };
}
