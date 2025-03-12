{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../../modules/homeManager/windowManager/hyprland.nix
  ];

  custom.windowManager.hyprland = {
    enable = true;
    settings = {
      monitors = [
        {
          name = "DP-1";
          width = 3840;
          height = 2160;
          refreshRate = 240;
          x = 0;
          y = 0;
          scale = 1.5;
        }
        {
          name = "DP-2";
          width = 2560;
          height = 1440;
          refreshRate = 144;
          x = 2560;
          y = 0;
          scale = 1.25;
        }
        {
          name = "HDMI-A-1";
          width = 3840;
          height = 2160;
          refreshRate = 60;
          x = 0;
          y = 0;
          scale = 2;
          enabled = false;
        }
      ];
    };
  };

  wayland.windowManager.hyprland = {
    settings = {
      xwayland = {
        force_zero_scaling = true;
      };
      exec-once = [
        "copyq --start-server & dunst & xrandr --output DP-1 --primary & streamcontroller -b"
      ];

      workspace =
        let
          makeWorkspace =
            workspace: monitor: range:
            "${toString workspace}, monitor:${monitor}, default:${
              lib.boolToString ((builtins.elemAt range 0) == workspace)
            }";
          generateWorkspaces = range: monitor: map (w: makeWorkspace w monitor range) range;
        in
        (generateWorkspaces (lib.range 1 3) "DP-1")
        ++ (generateWorkspaces (lib.range 4 6) "DP-2")
        ++ (generateWorkspaces (lib.range 7 9) "HDMI-A-1");

      general = {
        gaps_in = 10;
        gaps_out = 15;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        resize_on_border = false;
        allow_tearing = false;
        layout = "dwindle";
      };

      decoration = {
        rounding = 10;
        blur = {
          enabled = true;
          size = 3;
          passes = 2;
          vibrancy = 0.1696;
        };
      };

      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      "$scratch_term" = "class:^(scratch_term)$";
      "$scratch_spotify" = "class:^(Spotify)$";
      windowrulev2 = [
        "suppressevent maximize, class:.*"
        "float,$scratch_term"
        "size 80% 85%, $scratch_term"
        "workspace special:scratch_term,$scratch_term"
        "center, $scratch_term"
        "float,$scratch_spotify"
        "size 80% 85%, $scratch_spotify"
        "workspace special:scratch_spotify,$scratch_spotify"
        "center, $scratch_spotify"
      ];

      "$mod" = "SUPER";
      "$terminal" = "kitty";
      "$menu" = "rofi -show drun";
      "$browser" = "firefox";
      "$chat" = "vesktop";
      "$files" = "thunar";

      bind = [
        "$mod SHIFT, S, exec, grim -g \"$(slurp -d)\" - | wl-copy"
        "$mod, Z, exec, if hyprctl clients | grep scratch_term; then echo 'scratch_term found'; else kitty --class scratch_term; fi"
        "$mod, Z, togglespecialworkspace, scratch_term"
        "$mod, P, exec, if hyprctl clients | grep scratch_spotify; then echo 'scratch_spotify found'; else spotify --class scratch_spotify; fi"
        "$mod, P, togglespecialworkspace, scratch_spotify"
        "$mod, F, exec, $browser"
        "$mod, Q, exec, $terminal"
        "$mod, R, exec, $menu"
        "$mod, D, exec, $chat"
        "$mod, E, exec, $files"
        "$mod, C, killactive"
        "$mod, M, exit"
        "$mod, V, togglefloating"
        "$mod, X, fullscreen"
        "$mod, H, movefocus, l"
        "$mod, L, movefocus, r"
        "$mod, K, movefocus, u"
        "$mod, J, movefocus, d"
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"
        "$mod SHIFT, l, resizeactive, 10 0"
        "$mod SHIFT, h, resizeactive, -10 0"
        "$mod SHIFT, k, resizeactive, 0 -10"
        "$mod SHIFT, j, resizeactive, 0 10"
      ];
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };
  };
}
