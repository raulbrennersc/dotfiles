{ config, pkgs, ... }:

{
  imports = [
    ./gnome.nix
  ];

  home.username = "raul";
  home.homeDirectory = "/home/raul";
  home.packages = with pkgs; [
    newt
    adw-gtk3

    unzip
    cmatrix
    fd
    fastfetch
    cava
    ripgrep
    less
    fzf
    wl-clipboard
    ffmpeg
    ddcutil
    cargo

    tmux
    neovim
    sqlite
    dbeaver-bin
    docker-compose
    stylua
    lua-language-server
    wezterm
    bruno

    qbittorrent
    vlc
    spotify
    libreoffice

    kdePackages.qtdeclarative
    gnomeExtensions.appindicator
  ];
  home.file = {
    ".docker".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/configs/.docker";
    ".local/bin/scripts".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/configs/scripts";
  };
  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin/scripts"
  ];
  home.sessionVariables = {
    EDITOR = "nvim";
    MANGOHUD = 1;
    QT_QPA_PLATFORMTHEME = "qt6ct";
    QS_ICON_THEME = "Papirus-Dark";
  };
  home.stateVersion = "26.05";

  programs.firefox = {
    enable = true;
    profiles.default = {
      isDefault = true;
      settings = {
        "media.hardwaremediakeys.enabled" = false;
      };
    };
    policies = {
      ExtensionSettings = {
        "{d634138d-c276-4fc8-924b-40a0ea21d284}" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/1password-x-password-manager/latest.xpi";
          default_area = "navbar";
        };
        "jid1-MnnxcxisBPnSXQ@jetpack" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
          default_area = "menupanel";
        };
      };
    };
  };

  programs.chromium = {
    enable = true;
    commandLineArgs = [
      "--disable-features=HardwareMediaKeyHandling"
    ];
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
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
  programs.oh-my-posh = {
    enable = true;
    enableBashIntegration = true;
    settings = fromTOML (builtins.readFile ../configs/oh-my-posh/custom.omp.toml);
  };
  programs.bash = {
    enable = true;
    initExtra = builtins.readFile ../configs/bashrc;
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
          insteadOf = "gh:";
        };
        "git@gitlab.com:" = {
          insteadOf = "gl:";
        };
        "https://github.com/" = {
          insteadOf = "ghs:";
        };
        "https://gitlab.com/" = {
          insteadOf = "gls:";
        };
      };
    };
  };

  xsession = {
    enable = true;
    initExtra = ''
      ${pkgs.xhost}/bin/xhost +local:
    '';
  };

  xdg.configFile = {
    "nvim".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/configs/nvim";
    "uwsm".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/configs/nvim";
    "tmux".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/configs/tmux";
    "wezterm".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/configs/wezterm";
    "fastfetch".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/configs/fastfetch";
    "cava".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/configs/cava";
    "solaar".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/configs/solaar";
    "ghostty".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/configs/ghostty";
    "MangoHud".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/configs/MangoHud";
    "autostart".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/configs/autostart";
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };
}
