# ZSH Shell Configuration with Powerlevel10k

{ config, pkgs, lib, ... }:

{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting = {
      enable = true;
      highlighters = [ "main" "brackets" "pattern" "regexp" "root" "line" ];
    };
    historySubstringSearch.enable = true;

    history = {
      ignoreDups = true;
      save = 10000;
      size = 10000;
    };

    oh-my-zsh = {
      enable = true;
    };

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = lib.cleanSource ./p10k-config;
        file = "p10k.zsh";
      }
    ];

    initContent = ''
      # Key bindings
      bindkey "\eh" backward-word
      bindkey "\ej" down-line-or-history
      bindkey "\ek" up-line-or-history
      bindkey "\el" forward-word
      
      # Source personal zshrc if it exists
      if [ -f $HOME/.zshrc-personal ]; then
        source $HOME/.zshrc-personal
      fi
    '';

    shellAliases = {
      sv = "sudo nvim";
      v = "nvim";
      c = "clear";
      rebuild = "sudo nixos-rebuild switch --flake .";
      ncg = "nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
      cat = "bat";
      ls = "eza --icons";
      ll = "eza --icons -la";
      tree = "eza --tree --icons";
    };
  };
}
