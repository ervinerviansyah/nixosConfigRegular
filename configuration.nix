{ config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];
	
  # Bootloader.
#boot.loader.grub.enable = true;
#boot.loader.grub.device = "/dev/sda";
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs"];

  # Konfigurasi mount point untuk partisi NTFS
  fileSystems."/mnt/universal-database" = {
    device = "/dev/disk/by-uuid/01DAA3E3F90F3CC0";
    fsType = "ntfs";
    options = [ "rw" "auto" "users" "exec" "uid=1000" "gid=100" "umask=0022" ];
  };

  # Opsi tambahan untuk systemd.mount
  #systemd.mounts."/mnt/universal-database" = {
  #  enable = true;
  #  description = "Mount Universal Database (NTFS)";
  #  wantedBy = [ "multi-user.target" ];
  #};

  # Hostname
  networking.hostName = "nixos"; 

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Jakarta";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "id_ID.UTF-8";
    LC_IDENTIFICATION = "id_ID.UTF-8";
    LC_MEASUREMENT = "id_ID.UTF-8";
    LC_MONETARY = "id_ID.UTF-8";
    LC_NAME = "id_ID.UTF-8";
    LC_NUMERIC = "id_ID.UTF-8";
    LC_PAPER = "id_ID.UTF-8";
    LC_TELEPHONE = "id_ID.UTF-8";
    LC_TIME = "id_ID.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Display Manager (Pilih Salah Satu)
    services.xserver.displayManager.gdm.enable = true;
    #services.displayManager.sddm.enable = true;
    #services.xserver.displayManager.lightdm.enable = true;
  
  # Desktop Environment (Pilih Salah Satu)
    services.xserver.desktopManager.gnome.enable = true;
    #services.desktopManager.plasma6.enable = true;
    #services.xserver.desktopManager.xfce.enable = true;

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = [ pkgs.epson-escpr ];
  };

  # Scanner
  hardware.sane = {
  enable = true;
  extraBackends = [ pkgs.epsonscan2 ];
  };

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account.
  users.users.ervin = {
    isNormalUser = true;
    description = "Ervin Erviansyah";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
    packages = with pkgs; [
    ];
   shell = pkgs.fish;
  };

  # Enable Cachix
  nix.settings.trusted-users = [ "root" "ervin" ];

# Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;

# Install steam
  programs.steam.enable = true;

# Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

# System Packages
  environment.systemPackages = with pkgs; [
  
  ];

# Enable the OpenSSH daemon.
  services.openssh.enable = true;

# Firewall
  networking.firewall.enable = false;
  system.copySystemConfiguration = false;

# System Version
  system.stateVersion = "24.11";

  # Flatpak
 services.flatpak.enable = true;

  # Automatic Garbage Collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Zram
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };

  # Waydroid
  #virtualisation.waydroid.enable = true;

  # Vnstat
  services.vnstat.enable = true;

# Hardware
  hardware.graphics = {
   enable = true;
   extraPackages = with pkgs; [
    rocmPackages.clr.icd
    ];
  };

  # Configuration Fish
  programs.fish = {
   enable = true;
   shellAliases = {
     ls = "eza";
     ll = "ls -l";
     la = "ls -al";
     du = "${pkgs.du-dust}/bin/dust";
     nupgrade = "sudo nixos-rebuild switch --upgrade";
     nconfig = "sudo nvim /etc/nixos/configuration.nix";
     nbuild = "sudo nixos-rebuild switch --upgrade";
     hconfig = "nvim ~/.config/home-manager/home.nix";
     hbuild = "home-manager build && home-manager switch";
     graph = "git log --all --decorate --oneline --graph";
   };
   };

# VirtualBox
virtualisation.virtualbox.host.enable = true;

# Virtual Machine
virtualisation.libvirtd = {
  enable = true;
  qemu = {
    package = pkgs.qemu_kvm;
    runAsRoot = true;
    swtpm.enable = true;
    ovmf = {
      enable = true;
      packages = [(pkgs.OVMF.override {
        secureBoot = true;
        tpmSupport = true;
      }).fd];
    };
  };
};


}
