{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/common-configuration.nix
  ];

  networking.hostName = "raul-xps";
  xdg.mime.enable = true;
  xdg.mime.defaultApplications = {
    "text/html" = "re.sonny.Junction.desktop";
    "x-scheme-handler/http" = "re.sonny.Junction.desktop";
    "x-scheme-handler/https" = "re.sonny.Junction.desktop";
    "x-scheme-handler/about" = "re.sonny.Junction.desktop";
    "x-scheme-handler/unknown" = "re.sonny.Junction.desktop";
  };
}
