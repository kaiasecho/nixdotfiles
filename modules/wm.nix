{ config, pkgs, inputs, ...}:

{
    services.getty.autologinUser = "kaia";

    programs.hyprland = {
        enable = true;
        xwayland.enable = true;
    };

    hardware.bluetooth = {
        enable = true;
        powerOnBoot = false;
    };
    services.power-profiles-daemon.enable = true;
    services.gvfs.enable = true;
    services.gnome.gnome-keyring.enable = true;

    environment.systemPackages = with pkgs; [
        inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
}