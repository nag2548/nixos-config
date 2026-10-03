{ pkgs, ... }:
{
  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      historySubstringSearch.enable = true;

      prezto.tmux.autoStartLocal = true;

      shellAliases = {
        rebuild = "sudo nixos-rebuild switch --flake ~/.schnee";
      };

      history = {
        size = 10000;
        ignoreAllDups = true;
      };

      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "python"
          "man"
          "docker"
          "docker-compose"
          "tmux"
        ];
      };
    };

    starship = {
      enable = true;
      enableZshIntegration = true;

      settings = {
        right_format = "$time";
        time.disabled = false;
      };
    };

    tmux = {
      enable = true;
      newSession = true;
      clock24 = true;
      mouse = true;
      escapeTime = 0;
      disableConfirmationPrompt = true;
      keyMode = "vi";
      terminal = "tmux-256color";

      plugins = with pkgs.tmuxPlugins; [
        sensible
        yank
        vim-tmux-navigator
        better-mouse-mode
        tmux-floax
        cpu
        battery
        {
          plugin = resurrect;
          extraConfig = ''
            set -g @resurrect-strategy-nvim 'session'
            set -g @resurrect-strategy-vim 'session'
            set -g @resurrect-capture-pane-contents 'on'
            set -g @resurrect-pane-contents-area 'visible'
            set -g @resurrect-processes '~vi ~lazygit ~opencode'
            set -g @resurrect-save-command-strategy 'linux_procfs'
          '';
        }
        {
          plugin = continuum;
          extraConfig = ''
            set -g @continuum-restore 'on'
            set -g @continuum-save-interval '5'
          '';
        }
      ];

      extraConfig = ''
        set -g extended-keys on
        set -as terminal-features 'xterm-kitty:extkeys'
        # tmux 3.5+: send keys to apps in CSI u format
        set -g extended-keys-format csi-u
      '';
    };

    kitty = {
      enable = true;
      shellIntegration.enableZshIntegration = true;
      enableGitIntegration = true;

      settings = {
        enable_audio_bell = false;
        scrollback_lines = 10000;
        update_check_interval = 0;
        font_size = 11;
        font_family = "FiraCode Nerd Font Mono";
        tab_bar_min_tabs = 1;
        tab_bar_edge = "bottom";
        tab_bar_style = "powerline";
        tab_powerline_style = "slanted";
        tab_title_template = "{title}{' :{}:'.format(num_windows) if num_windows > 1 else ''}";
        window_padding_width = "0 8";
      };

      keybindings = {
        "shift+enter" = "send_text all \\x1b[13;2u";
      };
      # themeFile = "Catppuccin-Mocha";
    };

    opencode.enable = true;

    zellij = {
      enable = true;

      settings = {
        show_startup_tips = false;
      };

      extraConfig = ''
        keybinds {
          shared_except "move" "locked" {
            unbind "Ctrl h"
            bind "Ctrl m" { SwitchToMode "Move"; }
          }
          move {
            unbind "Ctrl h"
            bind "Ctrl m" { SwitchToMode "Normal"; }
          }
        }
      '';
    };
  };
}
