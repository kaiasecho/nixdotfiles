{ config, pkgs, ... }:

{
    programs.steam.enable = true;
    programs.nix-ld.enable = true;

    programs.firefox.enable = true;

    programs.obs-studio = {
        enable = true;
        package = (
        pkgs.obs-studio.override {
            cudaSupport = true;  
        }
        );
    };

    services.flatpak.enable = true;
    services.gnome.gnome-software.enable = true;

    environment.systemPackages = with pkgs; [
        kitty
        git
        uv
        ffmpeg

        vscode
        loupe
        nautilus
        davinci-resolve
        discord

        vlc
        libvlc
    ];
}