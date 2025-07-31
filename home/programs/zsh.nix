{ config, lib, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    autocd = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history.append = true;

    initContent = ''
      if [ -z "$INTELLIJ_ENVIRONMENT_READER" ]; then
        if command -v fish >/dev/null 2>&1; then
          exec fish -l
        fi
      fi
    '';
  };
}
