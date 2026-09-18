{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    papirus-icon-theme
    gnomeExtensions.brightness-control-using-ddcutil
    gnomeExtensions.system-monitor
    gnomeExtensions.dash-to-dock
    gnomeExtensions.color-picker
    gnomeExtensions.appindicator
    gnomeExtensions.vitals
  ];

  dconf.settings = {
    "org/gnome/mutter" = {
      dynamic-workspaces = false;
    };

    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = with pkgs.gnomeExtensions; [
        brightness-control-using-ddcutil.extensionUuid
        system-monitor.extensionUuid
        dash-to-dock.extensionUuid
        color-picker.extensionUuid
        appindicator.extensionUuid
        vitals.extensionUuid
      ];

      favorite-apps = [
        "org.gnome.Nautilus.desktop"
        "org.wezfurlong.wezterm.desktop"
        "firefox.desktop"
        "spotify.desktop"
        "dbeaver.desktop"
      ];
    };

    "org/gnome/shell/keybindings" = {
      focus-active-notification = [];
      switch-to-application-1 = [];
      switch-to-application-2 = [];
      switch-to-application-3 = [];
      switch-to-application-4 = [];
      toggle-message-tray = [];
      show-screenshot-ui = [ "<Shift><Super>s" ];
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "close:appmenu";
      num-workspaces = 2;
    };

    "org/gnome/desktop/wm/keybindings" = {
      activate-window-menu = [];
      close = [ "<Super>q" ];
      maximize = [ "<Super>m" ];
      move-to-workspace-1 = [ "<Shift><Super>1" ];
      move-to-workspace-2 = [ "<Shift><Super>2" ];
      move-to-workspace-3 = [ "<Shift><Super>3" ];
      move-to-workspace-4 = [ "<Shift><Super>4" ];
      show-desktop = [ "<Super>d" ];
      switch-applications = [];
      switch-applications-backward = [];
      switch-input-source = [];
      switch-input-source-backward = [];
      switch-to-workspace-1 = [ "<Super>1" ];
      switch-to-workspace-2 = [ "<Super>2" ];
      switch-to-workspace-3 = [ "<Super>3" ];
      switch-to-workspace-4 = [ "<Super>4" ];
      switch-to-workspace-left = [ "<Super>j" ];
      switch-to-workspace-right = [ "<Super>k" ];
      switch-windows = [ "<Alt>Tab" ];
      switch-windows-backward = [ "<Shift><Alt>Tab" ];
      unmaximize = [ "<Super>Down" "<Alt>F5" ];
    };

    "org/gnome/desktop/peripherals/mouse" = {
      accel-profile = "flat";
    };

    "org/gnome/desktop/input-sources" = {
      xkb-options = [ "terminate:ctrl_alt_bksp" "lv3:menu_switch" "compose:ralt" "caps:escape" ];
    };

    "org/gnome/desktop/interface" = {
      show-battery-percentage = true;
      clock-format = "24h";
      clock-show-seconds = true;
      color-scheme = "prefer-dark";
      accent-color = "blue";
      enable-hot-corners = false;
      icon-theme = "Papirus-Dark";
      gtk-theme = "Adwaita-dark";
      clock-show-weekday = true;
    };

    "org/gnome/desktop/file-chooser" = {
      clock-format = "24h";
    };

    "org/gnome/desktop/search-providers" = {
      disabled = [
        "org.gnome.Calculator.desktop"
        "org.gnome.Calendar.desktop"
        "org.gnome.clocks.desktop"
        "org.gnome.Contacts.desktop"
        "org.gnome.Characters.desktop"
        "org.gnome.Epiphany.desktop"
      ];
      sort-order = [
        "org.gnome.Settings.desktop"
        "org.gnome.Nautilus.desktop"
        "org.gnome.Contacts.desktop"
        "org.gnome.Software.desktop"
        "org.gnome.Epiphany.desktop"
        "org.gnome.Characters.desktop"
        "org.gnome.Calculator.desktop"
        "org.gnome.Calendar.desktop"
        "org.gnome.clocks.desktop"
        "org.gnome.Weather.desktop"
      ];
    };

    "org/gnome/system/location" = {
      enabled = false;
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      home = [ "<Super>e" ];
      custom-keybindings = [ "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/" ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>t";
      command = "wezterm";
      name = "wezterm";
    };

    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-battery-type = "nothing";
      sleep-inactive-ac-type = "nothing";
      power-button-action = "nothing";
    };

    "org/gnome/desktop/session" = {
      idle-delay = lib.hm.gvariant.mkUint32 0;
    };

## EXTENSIONS
    "org/gnome/shell/extensions/display-brightness-ddcutil" = {
      button-location = 1;
      ddcutil-binary-path = "${pkgs.ddcutil}/bin/ddcutil";
      ddcutil-queue-ms = 130.0;
      ddcutil-sleep-multiplier = 40.0;
      decrease-brightness-shortcut = [ "XF86MonBrightnessDown" ];
      hide-system-indicator = true;
      increase-brightness-shortcut = [ "XF86MonBrightnessUp" ];
      position-system-menu = 3.0;
      show-osd = true;
      step-change-keyboard = 6.0;
    };

    "org/gnome/shell/extensions/dash-to-dock" = {
      always-center-icons = false;
      apply-custom-theme = true;
      background-color = "rgb(48,48,48)";
      background-opacity = 1.0;
      click-action = "focus-minimize-or-previews";
      custom-background-color = true;
      custom-theme-customize-running-dots = true;
      custom-theme-running-dots-color = "rgb(130,170,255)";
      custom-theme-shrink = true;
      dash-max-icon-size = 48;
      dock-fixed = false;
      dock-position = "BOTTOM";
      extend-height = false;
      height-fraction = 0.9;
      hot-keys = false;
      intellihide-mode = "FOCUS_APPLICATION_WINDOWS";
      isolate-workspaces = true;
      running-indicator-dominant-color = false;
      running-indicator-style = "DOTS";
      show-mounts = false;
      show-show-apps-button = true;
      show-trash = false;
      transparency-mode = "FIXED";
    };

    "org/gnome/shell/extensions/color-picker" = {
      enable-shortcut = true;
      color-picker-shortcut = [ "<Super>b" ];
      enable-systray = false;
    };

    "org/gnome/shell/extensions/blur-my-shell/applications" = {
      blur = false;
    };

    "org/gnome/shell/extensions/blur-my-shell/dash-to-dock" = {
      blur = false;
    };

    "org/gnome/shell/extensions/system-monitor" = {
      show-memory = true;
      show-cpu = true;
      show-download = false;
      show-upload = false;
      show-swap = false;
    };

    "org/gnome/desktop/interface" = {
      cursor-theme = "Adwaita";
      cursor-size = 24;
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
  };
}
