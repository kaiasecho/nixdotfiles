{ config, pkgs, lib, ... }:

let
  lua = lib.generators.mkLuaInline;
  dsp = {
    exec = cmd: lua ''hl.dsp.exec_cmd("${cmd}")'';
    close = lua "hl.dsp.window.close()";
    float = lua ''hl.dsp.window.float({ action = "toggle" })'';
    fullscreen = lua "hl.dsp.window.fullscreen()";
    pseudo = lua "hl.dsp.window.pseudo()";
    layout = msg: lua ''hl.dsp.layout("${msg}")'';
    focus = dir: lua ''hl.dsp.focus({ direction = "${dir}" })'';
    swap = dir: lua ''hl.dsp.window.swap({ direction = "${dir}" })'';
    toggleSpecial = name: lua ''hl.dsp.workspace.toggle_special("${name}")'';
    moveToSpecial = name: lua ''hl.dsp.window.move({ workspace = "special:${name}" })'';
    focusWorkspace = ws: lua ''hl.dsp.focus({ workspace = "${toString ws}" })'';
    moveToWorkspace = ws: lua ''hl.dsp.window.move({ workspace = "${toString ws}" })'';
    drag = lua "hl.dsp.window.drag()";
    resize = lua "hl.dsp.window.resize()";
  };
  bind = keys: dispatcher: {_args = [ keys dispatcher ]; };
  bindOpts = keys: dispatcher: opts: {_args = [ keys dispatcher opts ]; }; 
in
{

  home.username = "kaia";
  home.homeDirectory = "/home/kaia";
  home.stateVersion = "26.05";
  home.sessionVariables = {
    XCURSOR_THEME = "capitaine-cursors";
    XCURSOR_SIZE = "24";
    HYPRCURSOR_THEME = "capitaine-cursors"; # Backup link for Hyprland
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      update = "sudo nixos-rebuild switch --flake /etc/nixos";
      edit = "code /etc/nixos";
    };
    profileExtra = ''
      if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
        exec start-hyprland
      fi
    '';
  };

  programs.fastfetch = {
    enable = true;
    settings = {
      modules = [
        "title"
        "separator"
        "os"
        "host"
        "kernel"
        "uptime"
        "packages"
        "shell"
        "display"
        "de"
        "wm"
        "wmtheme"
        "theme"
        "icons"
        "font"
        "cursor"
        "terminal"
        "terminalfont"
        "cpu"
        "gpu"
        "memory"
        "swap"
        "disk"
        "break" 
      ];
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    font = {
      name = "Noto Sans";
      size = 10;
    };
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
    cursorTheme = {
      package = pkgs.capitaine-cursors;
      name = "capitaine-cursors";
      size = 24;
    };
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
  };

  home.pointerCursor = {
    package = pkgs.capitaine-cursors;
    name = "capitaine-cursors";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      font-name = "Noto Sans 10";
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  };

  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    settings = {
      monitor = [
        {
        output = "DP-1";
        mode = "1920x1080@143.98";
        position = "0x0";
        scale = "1.0";
              }
        {
        output = "HDMI-A-1";
        mode = "1920x1080@60";
        position = "1920x0";
        scale = "1.0";
        }
      ];
      config = {
        general = {
          gaps_in = 5;
          gaps_out = 10;
          border_size = 1;
          col = {
            active_border = "rgb(e1e1e1)";
            inactive_border = "rgb(151515)";
          };
        };

        decoration = {
          rounding = 10;
          active_opacity = 1.0;
          inactive_opacity = 1.0;
          shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
          };
          blur = {
            enabled = true;
            size = 10;
            vibrancy = 0.1696;
          };
        };

        animations = {
          enabled = true;
        };

        misc = {
          force_default_wallpaper = -1;
          disable_hyprland_logo = true;
        };

        input = {
          kb_layout = "si";
          accel_profile = "flat";
          force_no_accel = true;
        };
      };
      layer_rule = [{
        name = "noctalia";
        match = {
          namespace = "^noctalia-(bar-.+|notification|dock|panel|osd)$";
        };
        ignore_alpha = 0.5;
        blur = true;
        xray = true;
        blur_popups = true;
      }];
      workspace_rule = [
        { workspace = "1"; monitor = "DP-1"; persistent = false; }
        { workspace = "2"; monitor = "HDMI-A-1"; persistent = false; }
        { workspace = "3"; monitor = "DP-1"; persistent = false; }
        { workspace = "4"; monitor = "HDMI-A-1"; persistent = false; }
        { workspace = "5"; monitor = "DP-1"; persistent = false; }
      ];
      bind = [
        (bind "SUPER + D" (dsp.exec "noctalia panel-toggle launcher"))
        (bind "SUPER + RETURN" (dsp.exec "kitty"))
        (bind "SUPER + Q" dsp.close)
        (bind "SUPER + T" dsp.float)
        (bind "SUPER + F" dsp.fullscreen)
        (bind "SUPER + left" (dsp.focus "left"))
        (bind "SUPER + right" (dsp.focus "right"))
        (bind "SUPER + up" (dsp.focus "up"))
        (bind "SUPER + down" (dsp.focus "down"))
        (bind "SUPER + SHIFT + left" (dsp.swap "left"))
        (bind "SUPER + SHIFT + right" (dsp.swap "right"))
        (bind "SUPER + SHIFT + up" (dsp.swap "up"))
        (bind "SUPER + SHIFT + down" (dsp.swap "down"))
        (bind "SUPER + X" (dsp.exec "noctalia msg volume-up"))
        (bind "SUPER + Y" (dsp.exec "noctalia msg volume-down"))
        (bind "SUPER + 1" (dsp.focusWorkspace 1))
        (bind "SUPER + 2" (dsp.focusWorkspace 2))
        (bind "SUPER + 3" (dsp.focusWorkspace 3))
        (bind "SUPER + 4" (dsp.focusWorkspace 4))
        (bind "SUPER + 5" (dsp.focusWorkspace 5))
        (bind "SUPER + SHIFT + 1" (dsp.moveToWorkspace 1))
        (bind "SUPER + SHIFT + 2" (dsp.moveToWorkspace 2))
        (bind "SUPER + SHIFT + 3" (dsp.moveToWorkspace 3))
        (bind "SUPER + SHIFT + 4" (dsp.moveToWorkspace 4))
        (bind "SUPER + SHIFT + 5" (dsp.moveToWorkspace 5))
        (bind "Print" (dsp.exec "grimblast copysave area"))
        (bindOpts "SUPER + mouse:272" dsp.drag { mouse = true; })
        (bindOpts "SUPER + mouse:273" dsp.resize { mouse = true; })
      ];
      on = {
        _args = [
          "hyprland.start"
	        (lua ''
          function()
            hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE")
            hl.exec_cmd("noctalia")
            hl.exec_cmd("uvx nvibrant 800 800")
          end
	       '')
        ];
      };
    };
  };  
}
