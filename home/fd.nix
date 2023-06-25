{ ... }: {
  xdg.configFile."fd/ignore".text = ''
    .*
    .git/
    node_modules/
    target/
    dist/
  '';
}

