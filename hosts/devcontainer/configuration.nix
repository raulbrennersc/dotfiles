{ config, pkgs, ... }: {
  home.username = "dev";
  home.homeDirectory = "/home/dev";
  home.stateVersion = "24.11";

  nix.package = pkgs.nix;
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  home.packages = with pkgs; [
    fzf
    neovim
    google-cloud-sdk
    stylua
    lua-language-server
    oh-my-posh
    tmux
    wezterm
    ripgrep
    fd
    oh-my-posh
    bash
    nixd
    nixfmt
    man
  ];

  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/configs/nvim";
  xdg.configFile."git/config".source = ../../configs/git/config;
  xdg.configFile."tmux/tmux.conf".source = ../../configs/tmux/tmux.conf;

  home.file.".docker/config.json".source = ../../configs/.docker/config.json;

  programs.home-manager.enable = true;
  programs.oh-my-posh = {
    enable = true;
    enableBashIntegration = true;
    settings = fromTOML (builtins.readFile ../../configs/oh-my-posh/custom.omp.toml);
  };
  programs.bash = {
    enable = true;
    initExtra = builtins.readFile ../../configs/bashrc;
    profileExtra = ''
      source /etc/environment
      source ~/.bashrc
      sudo chown dev:dev /var/run/docker.sock 2>/dev/null || true
    '';
  };
}
