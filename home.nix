{ config, pkgs, ... }:

{
  home.username = "raul";
  home.homeDirectory = "/home/raul";

  home.packages = with pkgs; [
    newt adw-gtk3 papirus-icon-theme

    unzip cmatrix fd fastfetch cava tmux neovim ripgrep less
    fzf wl-clipboard ffmpeg imagemagick slurp grim ddcutil
    brightnessctl pulsemixer bluetui impala

    qbittorrent chromium alacritty vlc firefox dbeaver-bin
    sqlite spotify steam nautilus gnome-disk-utility
    wezterm ghostty

    hyprpaper hyprlock hyprpicker
    quickshell hyprshot libnotify

    docker-compose stylua lua-language-server
    kdePackages.qtdeclarative
  ];

  programs.oh-my-posh = {
    enable = true;
    enableBashIntegration = true;
  };

  home.file = {
    ".docker".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/configs/.docker";
    ".local/bin/scripts".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/configs/scripts";
  };

  xdg.configFile = {
    "nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/configs/nvim";
    "uwsm".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/configs/nvim";
    "hypr".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/configs/hypr";
    "tmux".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/configs/tmux";
    "alacritty".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/configs/alacritty";
    "wezterm".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/configs/wezterm";
    "fastfetch".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/configs/fastfetch";
    "cava".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/configs/cava";
    "solaar".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/configs/solaar";
    "quickshell".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/configs/quickshell";
    "ghostty".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/configs/ghostty";
    "MangoHud".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/configs/MangoHud";
    "autostart".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/configs/autostart";
  };

  xdg.desktopEntries = {
    tui-bluetooth = {
      name = "Bluetooth";
      exec = "tui-bluetooth";
      icon = "bluetooth";
      terminal = true;
      categories = ["System"];
    };

    devcontainer = {
      name = "Devcontainer Connect";
      exec = "devcontainer-connect";
      icon = "";
      terminal = false;
      categories = ["System"];
    };

    wifi = {
      name = "Wifi";
      exec = "tui-wifi";
      icon = "network-wireless-symbolic";
      terminal = false;
      categories = ["System"];
    };
  };

  programs.bash = {
    enable = true;
    initExtra = builtins.readFile ./configs/bashrc;
  };

  programs.git = {
    enable = true;

    settings = {
      user = {
        email = "raulbrennersc@gmail.com";
        name = "Raul Costa";
      };

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

  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin/scripts"
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    MANGOHUD=1;
    QT_QPA_PLATFORMTHEME = "qt6ct";
    QS_ICON_THEME = "Papirus-Dark";
  };

  programs.ssh = {
    enable = true;
    settings = {
      "*.devcontainer" = {
        HostName = "localhost";
        User = "dev";
        ForwardAgent = true;
        ForwardX11 = true;
        ForwardX11Trusted = true;
      };
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    cursorTheme = {
      package = pkgs.nordzy-cursor-theme;
      name = "Nordzy-cursors";
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.nordzy-cursor-theme;
    name = "Nordzy-cursors";
    size = 24;
  };


  home.stateVersion = "26.05";
}
