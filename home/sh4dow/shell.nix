{config,...}:
let 
  dotfiles = "${config.home.homeDirectory}/nixos-config/dotfiles";
in
{
  programs.fish={
    enable=true;
    interactiveShellInit = ''
      source ${dotfiles}/fish/config.fish
    '';
  };
  programs.starship.enable=true;
}
