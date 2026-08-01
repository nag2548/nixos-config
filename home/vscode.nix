{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;

    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        dracula-theme.theme-dracula
        yzhang.markdown-all-in-one
        jnoortheen.nix-ide
        christian-kohler.path-intellisense
      ];

      enableUpdateCheck = true;
      enableExtensionUpdateCheck = true;

      userSettings = {
        "editor.formatOnSave" = true;
        "diffEditor.ignoreTrimWhitespace" = false;
        "files.autoSave" = "afterDelay";
        "workbench.colorTheme" = "Dracula Theme";
        # "vim.handleKeys" = {
        #   "<C-p>" = false;
        #   "<C-d>" = true;
        #   "<C-s>" = false;
        #   "<C-z>" = false;
        # };
      };

      keybindings = [
        {
          key = "ctrl+3";
          command = "workbench.action.showCommands";
        }
        {
          key = "ctrl+shift+r";
          command = "workbench.action.quickOpen";
        }
        {
          key = "ctrl+h";
          command = "workbench.action.findInFiles";
        }
        {
          key = "ctrl+shift+t";
          command = "workbench.action.showAllSymbols";
        }
        {
          key = "ctrl+f3";
          command = "outline.focus";
        }
        {
          key = "ctrl+l";
          command = "workbench.action.gotoLine";
        }
        {
          key = "ctrl+w";
          command = "workbench.action.closeActiveEditor";
        }
        {
          key = "ctrl+shift+s";
          command = "workbench.action.files.saveAll";
        }
        {
          key = "ctrl+alt+s";
          command = "workbench.action.files.saveAs";
        }
        {
          key = "ctrl+alt+t";
          command = "workbench.action.terminal.toggleTerminal";
        }
        {
          key = "ctrl+m";
          command = "workbench.action.toggleSidebarVisibility";
        }
        {
          key = "ctrl+e";
          command = "workbench.action.showEditorsInActiveGroup";
        }
        {
          key = "ctrl+shift+w";
          command = "workbench.action.closeAllEditors";
        }
        {
          key = "ctrl+shift+f4";
          command = "workbench.action.closeAllEditors";
        }
        {
          key = "f12";
          command = "workbench.action.focusActiveEditorGroup";
        }
        {
          key = "ctrl+shift+[";
          command = "workbench.action.splitEditor";
        }
        {
          key = "ctrl+shift+c";
          command = "editor.action.commentLine";
          when = "editorTextFocus";
        }
        {
          key = "ctrl+7";
          command = "editor.action.commentLine";
          when = "editorTextFocus";
        }
        {
          key = "ctrl+shift+/";
          command = "editor.action.blockComment";
          when = "editorTextFocus";
        }
        {
          key = "shift+alt+y";
          command = "editor.action.toggleWordWrap";
          when = "editorTextFocus";
        }
        {
          key = "ctrl+alt+j";
          command = "editor.action.joinLines";
          when = "editorTextFocus";
        }
        {
          key = "ctrl+o";
          command = "workbench.action.gotoSymbol";
          when = "editorTextFocus";
        }
        {
          key = "ctrl+shift+f";
          command = "editor.action.formatSelection";
          when = "editorTextFocus && editorHasSelection";
        }
        {
          key = "ctrl+shift+f";
          command = "editor.action.formatDocument";
          when = "editorTextFocus && !editorHasSelection";
        }
        {
          key = "ctrl+alt+down";
          command = "editor.action.copyLinesDownAction";
          when = "editorTextFocus";
        }
        {
          key = "ctrl+alt+win+down";
          command = "editor.action.copyLinesDownAction";
          when = "editorTextFocus";
        }
        {
          key = "ctrl+alt+up";
          command = "editor.action.copyLinesUpAction";
          when = "editorTextFocus";
        }
        {
          key = "ctrl+alt+win+up";
          command = "editor.action.copyLinesUpAction";
          when = "editorTextFocus";
        }
        {
          key = "alt+down";
          command = "editor.action.moveLinesDownAction";
          when = "editorTextFocus";
        }
        {
          key = "alt+up";
          command = "editor.action.moveLinesUpAction";
          when = "editorTextFocus";
        }
        {
          key = "ctrl+d";
          command = "editor.action.deleteLines";
          when = "editorTextFocus";
        }
        {
          key = "shift+enter";
          command = "editor.action.insertLineAfter";
          when = "editorTextFocus && !editorReadonly";
        }
        {
          key = "ctrl+shift+delete";
          command = "deleteAllRight";
          when = "editorTextFocus";
        }
        {
          key = "alt+shift+s";
          command = "editor.action.sourceAction";
          when = "editorTextFocus";
        }
        {
          key = "alt+shift+r";
          command = "editor.action.rename";
          when = "editorTextFocus";
        }
        {
          key = "ctrl+shift+o";
          command = "editor.action.organizeImports";
          when = "editorTextFocus && !editorReadonly && supportedCodeAction =~ /(\\s|^)source\\.organizeImports\\b/";
        }
        {
          key = "ctrl+space";
          command = "editor.action.triggerSuggest";
          when = "editorTextFocus";
        }
        {
          key = "ctrl+.";
          command = "editor.action.marker.next";
          when = "editorFocus && !editorReadonly";
        }
        {
          key = "f3";
          command = "editor.action.goToDeclaration";
          when = "editorTextFocus";
        }
        {
          key = "ctrl+1";
          command = "editor.action.quickFix";
          when = "editorTextFocus";
        }
        {
          key = "ctrl+shift+g";
          command = "editor.action.referenceSearch.trigger";
          when = "editorTextFocus";
        }
        {
          key = "ctrl+shift+b";
          command = "editor.debug.action.toggleBreakpoint";
          when = "editorTextFocus";
        }
        {
          key = "ctrl+shift+x";
          command = "editor.action.transformToUppercase";
          when = "editorTextFocus";
        }
        {
          key = "ctrl+shift+y";
          command = "editor.action.transformToLowercase";
          when = "editorTextFocus";
        }
        {
          key = "ctrl+k";
          command = "editor.action.nextSelectionMatchFindAction";
          when = "editorTextFocus";
        }
        {
          key = "ctrl+shift+k";
          command = "editor.action.previousSelectionMatchFindAction";
          when = "editorTextFocus";
        }
        {
          key = "alt+shift+t";
          command = "editor.action.refactor";
          when = "editorHasCodeActionsProvider && editorTextFocus && !editorReadonly";
        }
        {
          key = "alt+shift+l";
          command = "editor.action.codeAction";
          when = "editorTextFocus";
          args = {
            kind = "refactor.extract.variable";
          };
        }
        {
          key = "alt+shift+m";
          command = "editor.action.codeAction";
          when = "editorTextFocus";
          args = {
            kind = "refactor.extract.function";
          };
        }
        {
          key = "alt+shift+v";
          command = "editor.action.codeAction";
          when = "editorTextFocus";
          args = {
            kind = "refactor.move";
          };
        }
        {
          key = "ctrl+left";
          command = "cursorWordPartLeft";
          when = "textInputFocus";
        }
        {
          key = "ctrl+right";
          command = "cursorWordPartRight";
          when = "textInputFocus";
        }
        {
          key = "ctrl+shift+left";
          command = "cursorWordPartLeftSelect";
          when = "textInputFocus";
        }
        {
          key = "ctrl+shift+right";
          command = "cursorWordPartRightSelect";
          when = "textInputFocus";
        }
        {
          key = "alt+left";
          command = "workbench.action.navigateBack";
        }
        {
          key = "alt+right";
          command = "workbench.action.navigateForward";
        }
        {
          key = "ctrl+f7";
          command = "workbench.action.focusNextPart";
        }
        {
          key = "shift+ctrl+f7";
          command = "workbench.action.focusPreviousPart";
        }
        {
          key = "f8";
          command = "workbench.action.debug.continue";
          when = "inDebugMode";
        }
        {
          key = "f11";
          command = "workbench.action.debug.start";
          when = "debuggersAvailable && debugState == 'inactive'";
        }
        {
          key = "ctrl+f11";
          command = "workbench.action.debug.run";
          when = "debuggersAvailable && debugState != 'initializing'";
        }
        {
          key = "f5";
          command = "workbench.action.debug.stepInto";
          when = "inDebugMode";
        }
        {
          key = "f7";
          command = "workbench.action.debug.stepOut";
          when = "inDebugMode";
        }
        {
          key = "f6";
          command = "workbench.action.debug.stepOver";
          when = "inDebugMode";
        }
        {
          key = "ctrl+f2";
          command = "workbench.action.debug.stop";
          when = "inDebugMode";
        }
        {
          key = "ctrl+q";
          command = "workbench.action.navigateToLastEditLocation";
          when = "editorTextFocus";
        }
        {
          key = "ctrl+alt+h";
          command = "references-view.showCallHierarchy";
          when = "editorHasCallHierarchyProvider";
        }
        {
          key = "f4";
          command = "java.action.showTypeHierarchy";
          when = "editorLangId == java && editorTextFocus";
        }
        {
          key = "alt+shift+up";
          command = "editor.action.smartSelect.expand";
          when = "editorTextFocus";
        }
      ];
    };
  };
}
