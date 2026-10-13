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

#desktop entry
  xdg.desktopEntries.mdfried = {
  name = "mdfried";
  comment = "Open Markdown files with mdfried";
  exec = "alacritty -e mdfried %f";
  terminal = false;
  type = "Application";
  categories = [ "Utility" ];
  mimeType = [ "text/markdown" ];
};
}
