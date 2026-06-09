{ config, pkgs, ...}:

{
    boot = {
        loader = {
        timeout = 0;
        };
        kernelPackages = pkgs.linuxPackages_latest;
        kernelParams = [ "quiet" "splash" "rd.udev.log_level=3" ];
        plymouth.enable = true;
    };

    fileSystems = {
        "/".options = [ "compress=zstd" ];
        "/home".options = [ "compress=zstd" ];
        "/nix".options = [ "compress=zstd" "noatime" ];
    };  
}