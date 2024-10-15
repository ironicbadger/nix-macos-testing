{ config, pkgs, modulesPath, name, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./networking.nix # generated at runtime by nixos-infect
    ../../common/nixos-config.nix
  ];

  ## DEPLOYMENT
  deployment.targetHost = name;
  deployment = {
    targetUser = "root";
    buildOnTarget = true;
  };

  boot.tmp.cleanOnBoot = true;
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

  ## zfs
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.extraPools = [ "ktz-cloud" ];
  services.zfs.autoScrub.enable = true;
  zramSwap.enable = true;

  networking.hostId = "7f8ded37";
  networking.hostName = "ktz-cloud";
  networking.domain = "";

  users.users.root.openssh.authorizedKeys.keys = [''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM7aI+bMjxTx7L9FRzJlk4UFCyYPzHs9Xs+vAhvPEYtk'' ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILkK1tv8BNtQJFt+n5yOJf6TQ/Ms9WkRi56MpyZOlWIk'' ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA2bSgQvelWzGLh4v1nv+OYx8YNijAikvVq4E9qXDWYN'' ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII+F3XpAIh4l8GfPgwoTqWQj0OdZRnnG9Ak4Z0wu0Upj'' ];
  users.defaultUserShell = pkgs.bash;
  programs.bash.interactiveShellInit = "figurine -f \"3d.flf\" ktz-cloud";

  environment.systemPackages = with pkgs; [
    ansible
    figurine
    htop
    inxi
    pciutils
    python3
    tmux
    vim
    wget
  ];

  services.tailscale.useRoutingFeatures = "server";
}