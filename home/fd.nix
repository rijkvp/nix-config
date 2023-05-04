{ ... }: {

  # Only whitelist certain directories
  xdg.configFile."fd/ignore".text = ''
    # Ignore everything
    *

    # Witelist 
    !docs
    !docs/**
    !uni*
    !uni*/**
    !repos
    !repos/**  

    # Still ignore stuff
    .git/
    node_modules/
    target/
    .*
  '';
}

