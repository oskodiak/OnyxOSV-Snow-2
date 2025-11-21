# Rofi Configuration
# Professional application launcher and dmenu replacement

{ config, pkgs, lib, ... }:

{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    
    theme = {
      "*" = {
        bg-col = "#2d1b4e";              # Deep purple from wallpaper
        bg-col-light = "#4c5be8";        # Snowflake blue
        border-col = "#6b5ce6";          # Medium purple
        selected-col = "#8a7ee8";        # Light purple
        blue = "#4c5be8";                # Snowflake blue
        fg-col = "#f0efff";              # Light/white
        fg-col2 = "#b8b3e6";            # Light purple accent
        grey = "#8a7ee8";                # Purple grey
        width = 600;
        font = "Hack 12";
      };
      
      element-text = {
        background-color = "inherit";
        text-color = "inherit";
      };
      
      element-icon = {
        background-color = "inherit";
        padding = "0 0 0 8px";
        size = "24px";
      };
      
      window = {
        height = "360px";
        border = "3px";
        border-color = "@border-col";
        background-color = "@bg-col";
      };
      
      mainbox = {
        background-color = "@bg-col";
      };
      
      inputbar = {
        children = ["prompt" "entry"];
        background-color = "@bg-col";
        border-radius = "5px";
        padding = "2px";
      };
      
      prompt = {
        background-color = "@blue";
        padding = "6px";
        text-color = "@bg-col";
        border-radius = "3px";
        margin = "20px 0px 0px 20px";
      };
      
      textbox-prompt-colon = {
        expand = false;
        str = ":";
      };
      
      entry = {
        padding = "6px";
        margin = "20px 0px 0px 10px";
        text-color = "@fg-col";
        background-color = "@bg-col";
      };
      
      listview = {
        border = "0px 0px 0px";
        padding = "6px 0px 0px";
        margin = "10px 0px 0px 20px";
        columns = 2;
        background-color = "@bg-col";
      };
      
      element = {
        padding = "5px";
        background-color = "@bg-col";
        text-color = "@fg-col";
      };
      
      "element selected" = {
        background-color = "@selected-col";
        text-color = "@fg-col2";
      };
      
      mode-switcher = {
        spacing = 0;
      };
      
      button = {
        padding = "10px";
        background-color = "@bg-col-light";
        text-color = "@grey";
        vertical-align = "0.5";
        horizontal-align = "0.5";
      };
      
      "button selected" = {
        background-color = "@bg-col";
        text-color = "@blue";
      };
    };
    
    extraConfig = {
      modi = "drun,run,window";
      icon-theme = "Adwaita";
      show-icons = true;
      terminal = "ghostty";
      drun-display-format = "{icon} {name}";
      location = 0;
      disable-history = false;
      hide-scrollbar = true;
      display-drun = "   Apps ";
      display-run = "   Run ";
      display-window = " 󰕰  Window ";
      display-Network = " 󰤨  Network ";
      sidebar-mode = true;
    };
  };
}