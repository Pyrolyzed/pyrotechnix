{ config, lib, pkgs, ... }:
{
  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.extraConfig = ''
      monitor=DP-3,3840x2160@240,0x0,1.5
      monitor=DP-1,2560x1440@144,0x0,1.25

      xwayland {
	force_zero_scaling = true
      }

      # Autostart programs
      exec-once = copyq --start-server & dunst & streamcontroller
      
      # Set cursor (lazy way)
      # exec-once = hyprctl setcursor Bibata-Modern-Classic 24

      workspace = 1, monitor:DP-3, default:true
      workspace = 2, monitor:DP-3
      workspace = 3, monitor:DP-3
      workspace = 4, monitor:DP-1, default:true
      workspace = 5, monitor:DP-1
      workspace = 6, monitor:DP-1

      general { 
	  gaps_in = 10
	  gaps_out = 15

	  border_size = 3

	  col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
	  col.inactive_border = rgba(595959aa)

	  resize_on_border = false 

	  allow_tearing = false

	  layout = dwindle
      }

      decoration {
	  rounding = 10
	  
	  blur {
	      enabled = true
	      size = 3
	      passes = 2
	      
	      vibrancy = 0.1696
	  }
      }

      animations {
	  enabled = true

	  bezier = myBezier, 0.05, 0.9, 0.1, 1.05

	  animation = windows, 1, 7, myBezier
	  animation = windowsOut, 1, 7, default, popin 80%
	  animation = border, 1, 10, default
	  animation = borderangle, 1, 8, default
	  animation = fade, 1, 7, default
	  animation = workspaces, 1, 6, default
      }

    dwindle {
      pseudotile = true 
      preserve_split = true
    }

    windowrulev2 = suppressevent maximize, class:.* 

    $terminal = kitty
    $menu = rofi -show drun
    $browser = firefox
    $chat = vesktop --enable-features=UseOzonePlatform --ozone-platform=wayland

    $mainMod = SUPER 

    bind = $mainMod SHIFT, S, exec, grim -g "$(slurp -d)" - | wl-copy
    bind = $mainMod, F, exec, $browser
    bind = $mainMod, Q, exec, $terminal
    bind = $mainMod, C, killactive,
    bind = $mainMod, M, exit,
    bind = $mainMod, V, togglefloating,
    bind = $mainMod, R, exec, $menu
    bind = $mainMod, X, fullscreen
    bind = $mainMod, D, exec, $chat

    bind = $mainMod, S, exec, pseudo
    bind = $mainMod, S, exec, resizeactive, exact 50% 50%

    # Move focus with mainMod + vim bindings
    bind = $mainMod, h, movefocus, l
    bind = $mainMod, l, movefocus, r
    bind = $mainMod, k, movefocus, u
    bind = $mainMod, j, movefocus, d

    # Switch workspaces with mainMod + [0-9]
    bind = $mainMod, 1, workspace, 1
    bind = $mainMod, 2, workspace, 2
    bind = $mainMod, 3, workspace, 3
    bind = $mainMod, 4, workspace, 4
    bind = $mainMod, 5, workspace, 5
    bind = $mainMod, 6, workspace, 6
    bind = $mainMod, 7, workspace, 7
    bind = $mainMod, 8, workspace, 8
    bind = $mainMod, 9, workspace, 9
    bind = $mainMod, 0, workspace, 10

    # Move active window to a workspace with mainMod + SHIFT + [0-9]
    bind = $mainMod SHIFT, 1, movetoworkspace, 1
    bind = $mainMod SHIFT, 2, movetoworkspace, 2
    bind = $mainMod SHIFT, 3, movetoworkspace, 3
    bind = $mainMod SHIFT, 4, movetoworkspace, 4
    bind = $mainMod SHIFT, 5, movetoworkspace, 5
    bind = $mainMod SHIFT, 6, movetoworkspace, 6
    bind = $mainMod SHIFT, 7, movetoworkspace, 7
    bind = $mainMod SHIFT, 8, movetoworkspace, 8
    bind = $mainMod SHIFT, 9, movetoworkspace, 9
    bind = $mainMod SHIFT, 0, movetoworkspace, 10

    # Scroll through existing workspaces with mainMod + scroll
    bind = $mainMod, mouse_down, workspace, e+1
    bind = $mainMod, mouse_up, workspace, e-1

    # Move/resize windows with mainMod + LMB/RMB and dragging
    bindm = $mainMod, mouse:272, movewindow
    bindm = $mainMod, mouse:273, resizewindow

    # Resize active windows with vim bindings
    bind = $mainMod SHIFT, l, resizeactive, 10 0
    bind = $mainMod SHIFT, h, resizeactive, -10 0
    bind = $mainMod SHIFT, k, resizeactive, 0 -10
    bind = $mainMod SHIFT, j, resizeactive, 0 10
  '';
}
