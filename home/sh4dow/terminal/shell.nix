{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    eza
    bat
    ripgrep
    fd
    fzf
    zoxide
    bottom
    duf
    dust
    direnv
    atuin
    starship
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";

    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";

    LESS = "-R -i -M -s -w -X -F";
    LESSHISTFILE = "/dev/null";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
    "$HOME/go/bin"
    "$HOME/.npm-global/bin"
    "$HOME/.deno/bin"
  ];

  programs.fish = {
    enable = true;

    shellAliases = {
      # Navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";

      # File operations
      cp = "cp -iv";
      mv = "mv -iv";
      rm = "rm -iv";
      mkdir = "mkdir -pv";

      # General
      h = "history";
      j = "jobs -l";
      c = "clear";
      clr = "clear";
      q = "exit";

      ps = "ps auxf";
      psg = "ps aux | grep -v grep | grep -i -e VSZ -e";
      ports = "netstat -tulanp";

      myip = "curl -s ifconfig.me";
      localip = ''ip addr show | grep "inet " | grep -v 127.0.0.1'';

      # Editors
      v = "nvim";

      # Git
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git pull";
      gd = "git diff";
      gco = "git checkout";
      gb = "git branch";
      gcl = "git clone";

      # Python
      py = "python";
      py3 = "python3";
      pip = "python -m pip";

      # Node
      ni = "npm install";
      nid = "npm install -D";
      nr = "npm run";
      nrd = "npm run dev";

      # Docker
      d = "docker";
      dc = "docker compose";
      dcu = "docker compose up";
      dcd = "docker compose down";
      dcl = "docker compose logs";

      # Rust
      cbuild = "cargo build";
      crun = "cargo run";
      ctest = "cargo test";
      ccheck = "cargo check";

      # Go
      gob = "go build";
      gor = "go run";
      got = "go test";

    };

    shellAbbrs = {
      gti = "git";
      chmox = "chmod +x";
      ipy = "ipython";

      tf = "terraform";
      k = "kubectl";

      vim = "nvim";
      vi = "nvim";
    };

    functions = {
      # Launch a separate Neovim configuration
      wvim = ''
        NVIM_APPNAME=wvim nvim $argv
      '';

      mkcd = ''
        mkdir -p $argv[1]
        cd $argv[1]
      '';

      nixrebuild = ''
            cd ~/nixos-config/
            git add .
            sudo nixos-rebuild switch --flake .#sh4dow-nixos
      '';

      extract = ''
        if test -f $argv[1]
          switch $argv[1]
            case '*.tar.bz2'
              tar xjf $argv[1]
            case '*.tar.gz'
              tar xzf $argv[1]
            case '*.bz2'
              bunzip2 $argv[1]
            case '*.rar'
              unrar x $argv[1]
            case '*.gz'
              gunzip $argv[1]
            case '*.tar'
              tar xf $argv[1]
            case '*.tbz2'
              tar xjf $argv[1]
            case '*.tgz'
              tar xzf $argv[1]
            case '*.zip'
              unzip $argv[1]
            case '*.Z'
              uncompress $argv[1]
            case '*.7z'
              7z x $argv[1]
            case '*'
              echo "'$argv[1]' cannot be extracted"
          end
        else
          echo "'$argv[1]' is not a valid file"
        end
      '';

      killp = ''
        if test -z "$argv[1]"
          echo "Usage: killp <process>"
          return 1
        end

        pkill -f $argv[1]
      '';

      backup = ''
        if test -z "$argv[1]"
          echo "Usage: backup <file>"
          return 1
        end

        cp $argv[1] $argv[1].bak
      '';

      weather = ''
        curl "wttr.in/$argv"
      '';

      cheat = ''
        curl "cheat.sh/$argv"
      '';

      qr = ''
        if test -z "$argv[1]"
          echo "Usage: qr <text>"
          return 1
        end

        curl "qrenco.de/$argv[1]"
      '';

      fcd = ''
        set dir (find . -type d 2>/dev/null | fzf)

        if test -n "$dir"
          cd "$dir"
        end
      '';

      frecent = ''
        zoxide query -l | fzf
      '';

      gcp = ''
        git add .
        git commit -m "$argv"
        git push
      '';

      largest = ''
        du -ah . 2>/dev/null | sort -rh | head -20
      '';

      ff = ''
        set query $argv
        set file ""

        if test -n "$query"
          set file (fzf \
            --query "$query" \
            --preview 'bat --style=numbers --color=always {}')
        else
          set file (fzf \
            --preview 'bat --style=numbers --color=always {}')
        end

        if test -n "$file"
          if test -S /tmp/nvim-server
            nvim --server /tmp/nvim-server --remote "$file"
          else
            nvim "$file"
          end
        end
      '';

      __sudo_last = ''
        if test -n "$history[1]"
          echo sudo $history[1]
        end
      '';
    };

    interactiveShellInit = ''
      # Fish
      set -g fish_greeting ""

      set fish_cursor_default block
      set fish_cursor_insert block
      set fish_cursor_replace_one underscore
      set fish_cursor_visual block

      # History
      set -g fish_history_max 100000

      # fzf
      set -gx FZF_DEFAULT_OPTS "--height 40% --layout=reverse --border"

      # Abbreviation for sudoing the previous command
      abbr -a pls --function __sudo_last

      # Tool integrations
      zoxide init fish | source
      direnv hook fish | source
      atuin init fish | source

      # fzf key bindings
      if type -q fzf
        fzf --fish | source
      end

      # Cargo
      if test -f "$HOME/.cargo/env.fish"
        source "$HOME/.cargo/env.fish"
      end
    '';
  };

  programs.starship = {
    enable = true;
  };

  xdg.configFile."starship.toml".source =
  config.lib.file.mkOutOfStoreSymlink
    "${config.home.homeDirectory}/nixos-config/dotfiles/starship/starship.toml";
}
