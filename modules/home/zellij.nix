# modules/home/zellij.nix
# Zellij terminal multiplexer configuration (startup layout)
{ pkgs, pkgs-unstable, ... }:

let
  copilotAgentArgs = builtins.concatStringsSep " " [
    "--allow-tool write"
    "--allow-tool copilot"
    "--allow-tool 'shell(bun:*)'"
    "--allow-tool 'shell(bunx:*)'"
    "--allow-tool 'shell(nix:*)'"
    "--allow-tool 'shell(nix-shell:*)'"
    "--allow-tool 'shell(zellij:*)'"
    "--allow-tool 'shell(sleep)'"
    "--allow-tool 'shell(ls)'"
    "--allow-tool 'shell(mkdir)'"
    "--allow-tool 'shell(printf)'"
    "--allow-tool 'shell(sed:*)'"
  ];

  mkCopilotCmd = dir: extraArgs: "cd ${dir} && copilot ${extraArgs}";

  # Fish one-liner: block until the opencode server responds on a given port.
  waitForPort = port:
    "while not curl -sf http://localhost:${toString port} >/dev/null 2>&1; sleep 1; end";

  zenCmd =
    "if type -q pybonsai; sleep 1; while true; clear; "
    + "pybonsai -x 30 -y 39 -S 10 -L 2 -l 5 -f -w 3.5; "
    + "${pkgs.python3}/bin/python3 -c 'import select, sys; ready, _, _ = select.select([sys.stdin], [], [], 86400); ready and sys.stdin.readline()'; "
    + "end; else; echo 'Just stay calm.'; "
    + "while true; sleep 3600; end; end";
in
{
  # Needed for standalone Home Manager activation (flake homeConfigurations.work).
  home.packages = [
    pkgs-unstable.zellij
  ];

  home.file.".config/zellij/config.kdl" = {
    force = true;
    text = ''
      default_layout "startup"
      theme "tokyo-night-dark-white"
      default_shell "${pkgs.fish}/bin/fish"
      // Start in lock mode (toggle with Ctrl+g).
      default_mode "locked"

       ui {
         pane_frames {
           rounded_corners true
           // Hide the "Zellij (session-name)" prefix from the tab bar.
           hide_session_name true
         }
       }

       plugins {
         // Allow showing keybinding hints on-demand when using the compact bar.
         // (Useful when running in locked mode to avoid Ctrl-* collisions.)
         compact-bar location="zellij:compact-bar" {
           tooltip "F1"
         }
       }

        keybinds {
           normal {
               bind "Alt t" { NewTab; }
               bind "Alt w" { CloseTab; }
               bind "Alt a" { GoToNextTab; }
               bind "Ctrl ö" { MoveTab "Left"; }
               bind "Ctrl ä" { MoveTab "Right"; }
               // Keep Alt+f free: macOS/Ghostty Option+Right becomes Meta-f (forward-word).
               bind "Alt p" { ToggleFloatingPanes; }
               bind "Alt j" { MoveFocus "Down"; }
               bind "Alt k" { MoveFocus "Up"; }
                bind "Alt c" { Run "fish" "-c" "ccdr" { name "Choose Directory"; floating true; close_on_exit true; }; }
               bind "Alt 1" { GoToTab 1; }
              bind "Alt 2" { GoToTab 2; }
              bind "Alt 3" { GoToTab 3; }
              bind "Alt 4" { GoToTab 4; }
              bind "Alt 5" { GoToTab 5; }
              bind "Alt 6" { GoToTab 6; }
              bind "Alt 7" { GoToTab 7; }
              bind "Alt 8" { GoToTab 8; }
              bind "Alt 9" { GoToTab 9; }
          }
           locked {
             // Allow tab switching and pane navigation even in locked mode (so Ctrl-based shell bindings keep working).
             bind "Alt t" { NewTab; }
             bind "Alt w" { CloseTab; }
             bind "Alt a" { GoToNextTab; }
             bind "Ctrl ö" { MoveTab "Left"; }
             bind "Ctrl ä" { MoveTab "Right"; }
              bind "Alt p" { ToggleFloatingPanes; }
              bind "Alt h" { MoveFocus "Left"; }
              bind "Alt j" { MoveFocus "Down"; }
              bind "Alt k" { MoveFocus "Up"; }
              bind "Alt l" { MoveFocus "Right"; }
               bind "Alt c" { Run "fish" "-c" "ccdr" { name "Choose Directory"; floating true; close_on_exit true; }; }
              bind "Alt 1" { GoToTab 1; }
             bind "Alt 2" { GoToTab 2; }
             bind "Alt 3" { GoToTab 3; }
             bind "Alt 4" { GoToTab 4; }
             bind "Alt 5" { GoToTab 5; }
             bind "Alt 6" { GoToTab 6; }
             bind "Alt 7" { GoToTab 7; }
             bind "Alt 8" { GoToTab 8; }
             bind "Alt 9" { GoToTab 9; }
          }
          shared_except "locked" {
            // Swap-layout navigation: use umlaut keys instead of [ and ].
            bind "Alt ö" { PreviousSwapLayout; }
            bind "Alt ä" { NextSwapLayout; }
           }
         }

      // Based on Zellij's built-in tokyo-night-dark theme, but with pure white text.
      themes {
        tokyo-night-dark-white {
          text_unselected {
            base 255 255 255
            background 26 27 38
            emphasis_0 255 158 100
            emphasis_1 42 195 222
            emphasis_2 158 206 106
            emphasis_3 187 154 247
          }
          text_selected {
            base 255 255 255
            background 56 62 90
            emphasis_0 255 158 100
            emphasis_1 42 195 222
            emphasis_2 158 206 106
            emphasis_3 187 154 247
          }
          ribbon_unselected {
            base 56 62 90
            background 169 177 214
            emphasis_0 249 51 87
            emphasis_1 255 255 255
            emphasis_2 122 162 247
            emphasis_3 187 154 247
          }
          ribbon_selected {
            base 56 62 90
            background 158 206 106
            emphasis_0 249 51 87
            emphasis_1 255 158 100
            emphasis_2 187 154 247
            emphasis_3 122 162 247
          }
          table_title {
            base 158 206 106
            background 0
            emphasis_0 255 158 100
            emphasis_1 42 195 222
            emphasis_2 158 206 106
            emphasis_3 187 154 247
          }
          table_cell_unselected {
            base 255 255 255
            // background 56 62 90
            background 26 27 38
            emphasis_0 255 158 100
            emphasis_1 42 195 222
            emphasis_2 158 206 106
            emphasis_3 187 154 247
          }
          table_cell_selected {
            base 255 255 255
            // background 26 27 38
            background 56 62 90
            emphasis_0 255 158 100
            emphasis_1 42 195 222
            emphasis_2 158 206 106
            emphasis_3 187 154 247
          }
          list_unselected {
            base 255 255 255
            // background 56 62 90
            background 26 27 38
            emphasis_0 255 158 100
            emphasis_1 42 195 222
            emphasis_2 158 206 106
            emphasis_3 187 154 247
          }
          list_selected {
            base 255 255 255
            // background 26 27 38
            background 56 62 90
            emphasis_0 255 158 100
            emphasis_1 42 195 222
            emphasis_2 158 206 106
            emphasis_3 187 154 247
          }
          frame_unselected {
            base 78 86 125
            background 0
            emphasis_0 255 158 100
            emphasis_1 42 195 222
            emphasis_2 187 154 247
            emphasis_3 0
          }
          frame_selected {
            base 158 206 106
            background 0
            emphasis_0 255 158 100
            emphasis_1 42 195 222
            emphasis_2 187 154 247
            emphasis_3 0
          }
          frame_highlight {
            base 255 158 100
            background 0
            emphasis_0 187 154 247
            emphasis_1 255 158 100
            emphasis_2 255 158 100
            emphasis_3 255 158 100
          }
          exit_code_success {
            base 158 206 106
            background 0
            emphasis_0 42 195 222
            emphasis_1 56 62 90
            emphasis_2 187 154 247
            emphasis_3 122 162 247
          }
          exit_code_error {
            base 249 51 87
            background 0
            emphasis_0 224 175 104
            emphasis_1 0
            emphasis_2 0
            emphasis_3 0
          }
          multiplayer_user_colors {
            player_1 187 154 247
            player_2 122 162 247
            player_3 0
            player_4 224 175 104
            player_5 42 195 222
            player_6 0
            player_7 249 51 87
            player_8 0
            player_9 0
            player_10 0
          }
        }
      }
      '';
    };

  home.file.".config/zellij/layouts/startup.kdl" = {
    force = true;
    text = ''
      layout {
        default_tab_template {
          pane size=1 borderless=true {
            plugin location="zellij:tab-bar"
          }
          children
          pane size=1 borderless=true {
            plugin location="compact-bar"
          }
        }

        tab name="User" focus=true {
          pane split_direction="Vertical" size="60%" {
            pane name="terminal" command="${pkgs.fish}/bin/fish" focus=true size="80%"
            pane name="zen" command="${pkgs.fish}/bin/fish" size="20%" {
              args "-c" "${zenCmd}"
            }
          }
          pane command="yazi" size="40%"
        }

        tab name="oc1" split_direction="Horizontal" {
          pane name="opencode" command="${pkgs.fish}/bin/fish" size="60%" {
            args "-c" "cd ~/repos; opencode; exec fish -i"
          }
          pane split_direction="Vertical" size="40%" {
            pane name="nvim" command="${pkgs.fish}/bin/fish" {
              args "-c" "cd ~/repos; nvim; exec fish -i"
            }
            pane name="yazi" command="${pkgs.fish}/bin/fish" {
              args "-c" "cd ~/repos; yazi; exec fish -i"
            }
          }
        }

        tab name="oc2" split_direction="Horizontal" {
          pane name="opencode" command="${pkgs.fish}/bin/fish" size="60%" {
            args "-c" "cd ~/repos; opencode; exec fish -i"
          }
          pane split_direction="Vertical" size="40%" {
            pane name="nvim" command="${pkgs.fish}/bin/fish" {
              args "-c" "cd ~/repos; nvim; exec fish -i"
            }
            pane name="yazi" command="${pkgs.fish}/bin/fish" {
              args "-c" "cd ~/repos; yazi; exec fish -i"
            }
          }
        }

        tab name="oc3" split_direction="Horizontal" {
          pane name="opencode" command="${pkgs.fish}/bin/fish" size="60%" {
            args "-c" "cd ~/repos; opencode; exec fish -i"
          }
          pane split_direction="Vertical" size="40%" {
            pane name="nvim" command="${pkgs.fish}/bin/fish" {
              args "-c" "cd ~/repos; nvim; exec fish -i"
            }
            pane name="yazi" command="${pkgs.fish}/bin/fish" {
              args "-c" "cd ~/repos; yazi; exec fish -i"
            }
          }
        }

        tab name="nvim" {
          pane command="nvim"
        }

        // tab name="server" {
        //   pane name="server" command="${pkgs.fish}/bin/fish" size="5%" {
        //     args "-c" "cd ~/repos; opencode serve --port 3010"
        //   }
        //   pane name="ask" command="${pkgs.fish}/bin/fish" focus=true {
        //     args "-c" "cd ~/repos; sleep 4; opencode attach http://localhost:3010"
        //   }
        //   pane name="ask (2)" command="${pkgs.fish}/bin/fish" {
        //     args "-c" "cd ~/repos; sleep 4; opencode attach http://localhost:3010"
        //   }
        // }

        tab name="nixos" {
          pane command="${pkgs.fish}/bin/fish" {
            args "-c" "cd ~/repos/nixos-config; opencode"
          }
          pane command="${pkgs.fish}/bin/fish" {
            args "-c" "cd ~/repos/nixos-config; opencode"
          }
        }
      }
    '';
  };

  home.file.".config/zellij/layouts/oc-tab.kdl" = {
    force = true;
    text = ''
      layout {
        default_tab_template {
          pane size=1 borderless=true {
            plugin location="zellij:tab-bar"
          }
          children
          pane size=1 borderless=true {
            plugin location="compact-bar"
          }
        }

        tab split_direction="Horizontal" {
          pane name="opencode" command="${pkgs.fish}/bin/fish" size="60%" {
            args "-c" "opencode; exec fish -i"
          }
          pane split_direction="Vertical" size="40%" {
            pane name="nvim" command="${pkgs.fish}/bin/fish" {
              args "-c" "nvim; exec fish -i"
            }
            pane name="yazi" command="${pkgs.fish}/bin/fish" {
              args "-c" "yazi; exec fish -i"
            }
          }
        }
      }
    '';
  };
}
