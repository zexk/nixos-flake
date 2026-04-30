{inputs, ...}: 
{
	flake.nixosModules.nh = { pkgs, ... }: {
  	programs.nh = {
    	enable = true;
    	clean.enable = true;
    	clean.extraArgs = "--keep-since 4d --keep 3";
    	flake = "/home/zexk/repos/nixos-flake"; # sets NH_OS_FLAKE variable for you
  	};
	};
}
