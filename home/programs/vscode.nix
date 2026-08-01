{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;

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
    };
  };
}
