{ config, pkgs, ... }:

{
  home.username = "raul";
  home.homeDirectory = "/home/raul";

   adw-gtk-theme


  home.packages = with pkgs; [
    newt adw-gtk-theme

    unzip cmatrix fd fastfetch cava tmux neovim ripgrep less
    fzf wl-clipboard ffmpeg imagemagick slurp grim ddcutil
    brightnessctl pulsemixer bluetui impala

    qbittorrent chromium alacritty vlc firefox dbeaver-bin
    sqlite spotify steam solaar nautilus gnome-disk-utility
    wezterm ghostty

    adw-gtk-theme

    hyprpaper hyprlock hypridle hyprpicker
    quickshell hyprshot

    docker-compose stylua lua-language-server
    kdePackages.qtdeclarative
  ];

  programs.oh-my-posh = {
    enable = true;
    enableBashIntegration = true;
    settings = builtins.fromJSON (builtins.readFile ./configs/oh-my-posh/custom.omp.toml);
  };

  home.file.".docker".source = ./configs/.docker;

  xdg.configFile = {
    "nvim".source = ./configs/nvim;
    "hypr".source = ./configs/hypr;
    "tmux".source = ./configs/tmux;
    "alacritty".source = ./configs/alacritty;
    "wezterm".source = ./configs/wezterm
    "fastfetch".source = ./configs/fastfetch;
    "cava".source = ./configs/cava;
    "solaar".source = ./configs/solaar;
    "quickshell".source = ./configs/quickshell;
    "ghostty".source = ./configs/ghostty;
    "MangoHud".source = ./configs/MangoHud;
    "autostart".source = ./configs/autostart;
  };

  home.file.".local/bin/scripts".source = ./configs/scripts;

  home.file.".local/share/applications/tui-bluetooth.desktop".source = ./configs/desktop/tui-bluetooth.desktop;
  home.file.".local/share/applications/devcontainer.desktop".source = ./configs/desktop/devcontainer.desktop;
  home.file.".local/share/applications/wifi.desktop".source = ./configs/desktop/wifi.desktop;
  home.file.".local/share/applications/bazecor.desktop".source = ./configs/desktop/bazecor.desktop;

  programs.bash = {
    enable = true;
    initExtra = builtins.readFile ./configs/bashrc;
  };

  programs.git = {
    enable = true;
    userName = "Raul Costa";
    userEmail = "raulbrennersc@gmail.com";

    extraConfig = {
      core = {
        editor = "vim";
      };
      
      init = {
        defaultBranch = "main";
      };
      
      push = {
        autoSetupRemote = true;
      };

      url = {
        "git@github.com:raulbrennersc/" = {
          insteadOf = "me:";
        };
        "git@github.com:" = {
          insteadOf = "ghs:";
        };
        "git@gitlab.com:" = {
          insteadOf = "gls:";
        };
        "https://github.com/" = {
          insteadOf = "gh:";
        };
        "https://gitlab.com/" = {
          insteadOf = "gl:";
        };
      };
    };
  };

  services.hyprpaper.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
    MANGOHUD=1
  };

  programs.ssh = {
    enable = true;

    matchBlocks = {
      "*.devcontainer" = {
        hostname = "localhost";
        user = "dev";
        forwardAgent = true;
        forwardX11 = true;
        forwardX11Trusted = true;
      };
    };
  };

  home.stateVersion = "24.05";
}
