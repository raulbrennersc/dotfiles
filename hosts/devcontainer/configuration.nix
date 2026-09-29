{ pkgs, ... }: {
  home.username = "dev";
  home.homeDirectory = "/home/dev";
  home.stateVersion = "24.11";

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
  ];

  xdg.configFile."nvim".source = ../../configs/nvim;
  xdg.configFile."git/config".source = ../../configs/git/config;
  xdg.configFile."tmux/tmux.conf".source = ../../configs/tmux/tmux.conf;

  home.file.".docker/config.json".source = ../../configs/.docker/config.json;

  programs.home-manager.enable = true;
  programs.bash = {
    enable = true;
    extraConfig = builtins.readFile ../../configs/.bashrc;
  };
}
