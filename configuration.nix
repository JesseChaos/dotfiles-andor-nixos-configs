# Micro graphical configuration that gets you started with a gnome3 (+ optionally xmonad) desktop
# * Note that gnome3 installs a *lot* of stuff from the internet
# * After modifying copying this configuration, run:
#   $ nixos-rebuild switch # sometimes it helps to try again
#                          # if this step fails for some reason
#   $ reboot

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Enable automatic updating of the system
  system.autoUpgrade.enable = true;

  # Boot settings.
  boot = {
    initrd = {
      # Disable journaling check on boot because virtualbox doesn't need it
      checkJournalingFS = false;
      kernelModules = ["fbcon"];
    };

    # Use boot splash
    plymouth.enable = true;

    # Use the GRUB 2 boot loader.
    loader.grub = {
      enable = true;
      version = 2;
      # Define on which hard drive you want to install Grub.
      device = "/dev/sda";
    };
  };
  
  # Enable networking.
  networking = {
    hostName = "NixOS-OnBL"; # Define your hostname.
    # hostId = # (use whatever was generated) 
    # wireless.enable = true;  # not needed with virtualbox
  };

  # Set your time zone.
  time.timeZone = "America/New_York";

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  environment.etc.current-nixos-config.source = ./.;
  # Currently broken for some reason
  # environment.variables.NIX_AUTO_RUN
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [

    #Core
    wget
    tree
    nano

    #General
    google-chrome
    docker
    android-udev-rules jmtpfs

    #Code
    git

    #Gnome3
    chrome-gnome-shell
    xorg.xinit
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.bash.enableCompletion = true;

  # List services that you want to enable.
  services = {
    # Enable the OpenSSH daemon.
    openssh.enable = true;
    
    # Enable CUPS to print documents.
    # services.printing.enable = true;
    
    # Enable Gnome keyring
    gnome3.gnome-keyring.enable = true;
    # Enable Gnome integrations
    gnome3.chrome-gnome-shell.enable = true;

    
    # Enable the X11 windowing system.
    xserver = {
      enable = true;
      layout = "us";
      # Touchpad support
      # libinput.enable = true;
      
      # Gnome desktop
      # * Slightly more familiar than KDE for people who are used to working with Ubuntu
      # * Gnome3 works out of the box with xmonad
      # * Gnome 3 works better with GDM and disable KDE display manager
      displayManager.gdm.enable = true;
      displayManager.sddm.enable = false;
      
      desktopManager = {
        gnome3.enable = true;
        default = "gnome3";
                
        # Disable KDE desktop manager
        plasma5.enable = false;
      };
      
      # Enable XMonad Desktop Environment. (Optional)
      windowManager = {
        xmonad.enable = true; 
        xmonad.enableContribAndExtras = true;
      };
      			
      # Use closed source NVidia drivers vs nouvaeu
      # videoDrivers = ["nvidia"];
    };  
    # Redshift light adjustment
    redshift = { 
      enable = true;
      
      # Round Hill, VA
      latitude = "39.13";
      longitude = "77.78";
    };
   
    # Not sure what this is
    # unclutter.enable = true;
  };
    
  # Virtualization stuff
  virtualization = {
    
    # Virtualbox
    # virtualbox.host = {
      # enable = true;
      # enableHardening = false;
      # addNetworkInterface = true;
    # };
    
    # Docker
    docker = {
      enable = true;
      storageDriver = "devicemapper";
    };
  };

  # List hardware tweaks
  # hardware.cpu.intel.updateMicrocode = true;
  hardware.opengl.driSupport32Bit = true;
  
  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.Jesse = {
    isNormalUser = true;
    uid = 1000;
    group = "users";
    extraGroups = [ "wheel" "networkmanager" "docker"];
    password = "demo";
  };

  # Set root password
  users.users.root.initialHashedPassword = "";
  users.users.root.password = "demo";

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.03"; # Did you read the comment?
  
}
