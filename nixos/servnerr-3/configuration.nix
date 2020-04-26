# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    # Hardware configuration.
    ./hardware-configuration.nix

    # Base system configuration.
    ./lib/nix.nix
    ./lib/system.nix
    ./lib/users.nix
    ./lib/node_exporter.nix

    # Service configuration.
    ./prometheus.nix
  ];

  networking = {
    # Host name and ID.
    hostName = "servnerr-3";
    hostId = "efdd2a1b";

    # No local firewall.
    firewall.enable = false;

    # Set up a bridge interface for VMs which is tagged into a lab VLAN.
    bridges.br0.interfaces = [ "enp6s0" ];

    # Use DHCP for all interfaces, but force the deprecated global setting off.
    useDHCP = false;
    interfaces = {
      enp5s0.useDHCP = true;
      br0.useDHCP = false;
    };
  };

  boot = {
    # Use the systemd-boot EFI boot loader.
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    # Enable ZFS.
    supportedFilesystems = [ "zfs" ];

    kernelParams = [
      # Enable serial console.
      "console=ttyS0,115200n8"
      # 24GiB ZFS ARC.
      "zfs.zfs_arc_max=25769803776"
    ];
  };

  # Start getty over serial console.
  systemd.services."serial-getty@ttyS0" = {
    enable = true;
    # Make sure agetty spawns at boot and always restarts whenever it
    # exits due to user logout.
    wantedBy = [ "multi-user.target" ];
    serviceConfig = { Restart = "always"; };
  };

  # Allow the use of Plex.
  nixpkgs.config.allowUnfree = true;

  # Packages specific to this machine. The base package set is defined in
  # lib/system.nix.
  environment.systemPackages = with pkgs; [ zfs ];

  services = {
    fwupd.enable = true;

    grafana = {
      enable = true;
      # Bind to all interfaces.
      addr = "";
    };

    # Enable the OpenSSH daemon.
    openssh = {
      enable = true;
      passwordAuthentication = false;
    };

    plex.enable = true;
  };

  # root SSH key for remote builds.
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOnN7NbaDhuuBQYPtlLtoUyyS6Q3cjJ/VPrw2IQ31R6F NixOS distributed build"
  ];
}
