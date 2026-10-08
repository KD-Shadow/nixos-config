{config,...}:{
  
#xdg user dirs
  xdg.userDirs = {
    enable = true;
    setSessionVariables = true;
  };


#fastfetch 
  xdg.configFile."fastfetch".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/nixos-config/dotfiles/fastfetch";
}
