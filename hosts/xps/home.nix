{ pkgs, ... }:

{
  imports = [
    ../../modules/common-home.nix
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
