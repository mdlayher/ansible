# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    # Hardware configuration.
    ./hardware-configuration.nix
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

    # Enable and tune ZFS (24GiB ARC).
    supportedFilesystems = [ "zfs" ];
    kernelParams = [ "zfs.zfs_arc_max=25769803776" ];
  };

  # Allow the use of Plex.
  nixpkgs.config.allowUnfree = true;

  # Set your time zone.
  time.timeZone = "America/Detroit";

  environment = {
    # Put ~/bin in PATH.
    homeBinInPath = true;

    # This is a headless machine.
    noXlibs = true;

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    systemPackages = with pkgs; [
      byobu
      git
      htop
      jq
      lm_sensors
      lshw
      nixfmt
      screenfetch
      tmux
      wget
      zfs
    ];
  };

  nix = {
    # Automatic Nix GC.
    gc = {
      automatic = true;
      dates = "04:00";
      options = "--delete-older-than 30d";
    };
    extraOptions = ''
      min-free = ${toString (500 * 1024 * 1024)}
    '';

    # Automatic store optimization.
    autoOptimiseStore = true;
  };

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

  # TODO: move into own prometheus.nix file.
  services.prometheus = {
    enable = true;
    exporters = { node.enable = true; };

    alertmanagers =
      [{ static_configs = [{ targets = [ "monitnerr-1:9093" ]; }]; }];

    scrapeConfigs = [{
      job_name = "node";
      static_configs = [{
        targets = [
          "monitnerr-1:9100"
          "nerr-3:9100"
          "routnerr-2:9100"
          "servnerr-3:9100"
        ];
      }];
    }];

    webExternalUrl = "https://prometheus.servnerr.com";
  };

  users.users = {
    matt = {
      isNormalUser = true;
      uid = 1000;
      extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.

      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN5i5d0mRKAf02m+ju+I1KrAYw3Ny2IHXy88mgyragBN Matt Layher (mdlayher@gmail.com)"
      ];
    };

    # root SSH key for remote builds.
    root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOnN7NbaDhuuBQYPtlLtoUyyS6Q3cjJ/VPrw2IQ31R6F NixOS distributed build"
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?
}
