{ ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user.name = "Your Name";
      user.email = "you@example.com";
      init.defaultBranch = "main";
    };
  };
}
