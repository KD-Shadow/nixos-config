let
  profile = "/home/sh4dow/.config/mozilla/firefox/fmroyqzj.default";
  chrome = ../../../assets/firefox/chrome;
in
{
  home.file = {
    "${profile}/chrome/userChrome.css" = {
      source = "${chrome}/userChrome.css";
      force = true;
    };
    "${profile}/chrome/userContent.css" = {
      source = "${chrome}/userContent.css";
      force = true;
    };
    "${profile}/chrome/add.svg" = {
      source = "${chrome}/add.svg";
      force = true;
    };
    "${profile}/chrome/addd.svg" = {
      source = "${chrome}/addd.svg";
      force = true;
    };
    "${profile}/user.js" = {
      source = ../../../assets/firefox/user.js;
      force = true;
    };
  };
}