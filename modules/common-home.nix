{ config, pkgs, ... }:

{
  imports = [ 
    ./gnome.nix 
  ];

  home.username = "raul";
  home.homeDirectory = "/home/raul";
  home.packages = with pkgs; [
    newt adw-gtk3 papirus-icon-theme

    unzip cmatrix fd fastfetch cava tmux neovim ripgrep less
    fzf wl-clipboard ffmpeg ddcutil

    qbittorrent chromium vlc firefox dbeaver-bin
    sqlite spotify wezterm ghostty

    docker-compose stylua lua-language-server
    kdePackages.qtdeclarative

    gnomeExtensions.appindicator
  ];
  home.file = {
    ".docker".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/configs/.docker";
    ".local/bin/scripts".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/configs/scripts";
  };
  home.sessionPath = [
    "${config.home.homeDirectory}/.local/bin/scripts"
  ];
  home.sessionVariables = {
    EDITOR = "nvim";
    MANGOHUD=1;
    QT_QPA_PLATFORMTHEME = "qt6ct";
    QS_ICON_THEME = "Papirus-Dark";
  };
  home.stateVersion = "26.05";

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
  programs.oh-my-posh = {
    enable = true;
    enableBashIntegration = true;
    settings = builtins.fromTOML (builtins.readFile ../configs/oh-my-posh/custom.omp.toml);

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


  xdg.configFile = {
    "nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/configs/nvim";
    "uwsm".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/configs/nvim";
    "tmux".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/configs/tmux";
    "wezterm".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/configs/wezterm";
    "fastfetch".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/configs/fastfetch";
    "cava".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/configs/cava";
    "solaar".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/configs/solaar";
    "ghostty".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/configs/ghostty";
    "MangoHud".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/configs/MangoHud";
    "autostart".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/configs/autostart";
  };
}
