# modules/home/zellij.nix
# Zellij terminal multiplexer configuration (startup layout)
{ pkgs, ... }:

let
  copilotAgentArgs =
    "--allow-tool write --allow-tool 'shell(bun:*)' --allow-tool 'shell(bunx:*)' --allow-tool 'shell(nix:flake check*)' --allow-tool 'shell(sleep)' --allow-tool 'shell(ls)' --allow-tool 'shell(mkdir)' --allow-tool 'shell(sed:*)'";

  mkCopilotCmd = dir: extraArgs: "cd ${dir} && copilot ${extraArgs}";
in
{
  # Needed for standalone Home Manager activation (flake homeConfigurations.work).
  home.packages = [
    pkgs.zellij
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
            bind "Alt j" { MoveFocus "Down"; }
            bind "Alt k" { MoveFocus "Up"; }
            bind "Alt 1" { GoToTab 1; }
            bind "Alt 2" { GoToTab 2; }
            bind "Alt 3" { GoToTab 3; }
            bind "Alt 4" { GoToTab 4; }
           bind "Alt 5" { GoToTab 5; }
          }
          locked {
            // Allow tab switching even in locked mode (so Ctrl-based shell bindings keep working).
            bind "Alt t" { NewTab; }
            bind "Alt w" { CloseTab; }
            bind "Alt a" { GoToNextTab; }
            bind "Alt 1" { GoToTab 1; }
            bind "Alt 2" { GoToTab 2; }
            bind "Alt 3" { GoToTab 3; }
            bind "Alt 4" { GoToTab 4; }
            bind "Alt 5" { GoToTab 5; }
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
          pane name="terminal" focus=true
          pane command="yazi"
        }

        tab name="agent" {
          pane command="${pkgs.fish}/bin/fish" {
            args "-c" "${mkCopilotCmd "~/repos/nixos-config" copilotAgentArgs}"
          }
          pane command="${pkgs.fish}/bin/fish" {
            args "-c" "${mkCopilotCmd "~/repos/nixos-config" copilotAgentArgs}"
          }
        }

        tab name="ask" {
          pane name="gpt 5.2" command="${pkgs.fish}/bin/fish" {
            args "-c" "${mkCopilotCmd "~/repos/ask" "--model gpt-5.2"}"
          }
          pane name="opus 4.6" command="${pkgs.fish}/bin/fish" {
            args "-c" "${mkCopilotCmd "~/repos/ask" "--model claude-opus-4.6"}"
          }
        }

        tab name="nvim" {
          pane command="nvim"
        }

        tab name="nixos" {
          pane command="${pkgs.fish}/bin/fish" {
            args "-c" "${mkCopilotCmd "~/repos/nixos-config" copilotAgentArgs}"
          }
          pane command="${pkgs.fish}/bin/fish" {
            args "-c" "${mkCopilotCmd "~/repos/nixos-config" copilotAgentArgs}"
          }
        }
      }
    '';
  };
}
