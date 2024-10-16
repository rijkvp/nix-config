{
  programs.newsboat = {
    enable = true;
    extraConfig = ''
      auto-reload yes
      reload-threads 6
      max-items 500

      browser "firefox %u"
      macro w set browser "nohup mpv %u --ytdl-format=\"bestvideo[height<=?1080]+bestaudio/best\" >/dev/null 2>&1 &" ; open-in-browser ; set browser "elinks %u"

      unbind-key ENTER
      unbind-key j
      unbind-key k
      unbind-key J
      unbind-key K
      bind-key j down
      bind-key k up
      bind-key l open
      bind-key h quit

      color background         default   default
      color listnormal         default   default  dim
      color listnormal_unread  default   default  bold
      color listfocus          black     cyan
      color listfocus_unread   black     cyan     bold
      color info               default   black
      color article            default   default
      color title              yellow    default   bold

      highlight article "^(Title):.*$" blue default
      highlight article "https?://[^ ]+" blue default
      highlight article "\\[image\\ [0-9]+\\]" yellow default

      highlight feedlist "~.*" blue default bold
      highlight feedlist ".*0/0.." default default invis
    '';
  };
}
