# SwayNC Notification Configuration
# Wallpaper-coordinated notification theme

{ config, pkgs, lib, ... }:

{
  services.swaync = {
    enable = true;
    
    settings = {
      positionX = "right";
      positionY = "top";
      layer = "overlay";
      control-center-layer = "top";
      layer-shell = true;
      cssPriority = "application";
      control-center-margin-top = 0;
      control-center-margin-bottom = 0;
      control-center-margin-right = 0;
      control-center-margin-left = 0;
      notification-2fa-action = true;
      notification-inline-replies = false;
      notification-icon-size = 64;
      notification-body-image-height = 100;
      notification-body-image-width = 200;
      timeout = 10;
      timeout-low = 5;
      timeout-critical = 0;
      fit-to-screen = true;
      control-center-width = 500;
      control-center-height = 600;
      notification-window-width = 500;
      keyboard-shortcuts = true;
      image-visibility = "when-available";
      transition-time = 200;
      hide-on-clear = false;
      hide-on-action = true;
      script-fail-notify = true;
    };
    
    style = ''
      /* OnyxOSV-Snow notification theme */
      .notification-row {
        outline: none;
        background: rgba(45, 27, 78, 0.9);
        border-radius: 12px;
        margin: 6px 12px;
        border: 2px solid #4c5be8;
      }

      .notification {
        background: transparent;
        padding: 0;
        margin: 0;
        border-radius: 12px;
        color: #f0efff;
      }

      .notification-content {
        background: transparent;
        padding: 12px;
        border-radius: 12px;
      }

      .summary {
        font-weight: bold;
        color: #4c5be8;
        font-size: 14px;
      }

      .time {
        color: #b8b3e6;
        font-size: 11px;
      }

      .body {
        color: #f0efff;
        font-size: 12px;
      }

      .control-center {
        background: rgba(45, 27, 78, 0.95);
        border: 2px solid #4c5be8;
        border-radius: 12px;
        margin: 12px;
        color: #f0efff;
      }

      .control-center-list {
        background: transparent;
      }

      .floating-notifications {
        background: transparent;
      }

      /* Buttons */
      .notification-action,
      .notification-default-action {
        padding: 4px 8px;
        margin: 2px;
        background: #4c5be8;
        color: #f0efff;
        border: none;
        border-radius: 6px;
      }

      .notification-action:hover,
      .notification-default-action:hover {
        background: #6b5ce6;
      }

      .close-button {
        background: #eb4d4b;
        color: #f0efff;
        border-radius: 50%;
        padding: 2px 6px;
      }
    '';
  };
}