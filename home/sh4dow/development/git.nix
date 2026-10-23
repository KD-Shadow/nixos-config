{ ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user.name = "KD-Shadow";
      user.email = "kdshadow189@gmail.com";
      init.defaultBranch = "main";
    };
  };
}
