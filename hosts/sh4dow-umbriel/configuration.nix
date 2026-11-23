{ inputs, config, pkgs, ... }:

let
  sunshineOutputScript = "${config.users.users.sh4dow.home}/.config/sunshine/umbriel-output.sh";
in
{
  imports = [
    ./hardware-configuration.nix
    ../common.nix
    ../greeter.nix
    inputs.umbriel.nixosModules.default
  ];

  programs.umbriel.enable = true;

  # https://docs.noctalia.dev/umbriel/streaming/
  services.sunshine = {
    enable = true;
    openFirewall = true;
    settings = {
      capture = "wlr";
      output_name = "sunshine";
      global_prep_cmd = builtins.toJSON [
        {
          do = "${sunshineOutputScript} create";
          undo = "${sunshineOutputScript} remove";
        }
      ];
    };
    applications = {
      # services.sunshine clears PATH in its systemd unit, so app commands need one.
      env.PATH = "${config.users.users.sh4dow.home}/.nix-profile/bin:/etc/profiles/per-user/sh4dow/bin:/run/current-system/sw/bin:/usr/bin:/bin";
      apps = [
        {
          name = "Steam Big Picture";
          detached = [ "steam steam://open/bigpicture" ];
          prep-cmd = [
            {
              do = "";
              undo = "steam steam://close/bigpicture";
            }
          ];
          image-path = "steam.png";
          # Per-game launch options should also set:
          #   WAYLANDDRV_PRIMARY_MONITOR=sunshine %command%
        }
      ];
    };
  };

  environment.systemPackages = with pkgs; [ jq ];

  networking.hostName = "sh4dow-umbriel";
  system.stateVersion = "26.11";
}
