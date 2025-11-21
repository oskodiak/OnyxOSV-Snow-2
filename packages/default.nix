# OnyxOSV-Snow Package Library
# Intelligent separation of simple packages vs complex programs

{ config, pkgs, lib, ... }:

{
  imports = [
    ./simple-packages.nix
    ./complex-programs.nix
    ./gaming.nix
    ./development.nix
    ./media.nix
  ];
}