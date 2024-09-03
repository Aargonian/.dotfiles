{ config, pkgs, username, hostname, lib, ... }:

let
  password = "Tw1light is best pony.";
  SSID = "ACRouter";
  SSIDpassword = "CumBurger69";
  interface = "wlan0";
in {

  # Enable Flakes
  nix.settings.experimental-features = "nix-command flakes";

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
    initrd.availableKernelModules = [ "xhci_pci" "usbhid" "usb_storage" ];
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };

  networking = {
    hostName = hostname;
    wireless = {
      enable = true;
      networks."${SSID}".psk = SSIDpassword;
      interfaces = [ interface ];
    };
  };

  environment.systemPackages = with pkgs; [ 
    vim 
    neovim
  ];

  services.openssh.enable = true;

  users = {
    mutableUsers = false;
    users."${username}" = {
      isNormalUser = true;
      password = password;
      extraGroups = [ "wheel" ];
    };
  };

  hardware.enableRedistributableFirmware = true;
  system.stateVersion = "24.05";
}
