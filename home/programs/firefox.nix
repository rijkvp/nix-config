{
  pkgs,
  ...
}:
let
  # Lepton theme https://github.com/black7375/Firefox-UI-Fix
  theme-dir = builtins.fetchGit {
    url = "https://github.com/black7375/Firefox-UI-Fix.git";
    rev = "d46476ce72ecf236389c568742a2c8ad68dab771"; # TOUPDATE: must be manually updated for newer versions
  };
  user-js = theme-dir.outPath + "/user.js";

  # From https://github.com/nix-community/home-manager/blob/master/modules/programs/firefox.nix
  firefoxConfigPath = ".mozilla/firefox";
  profileName = "default";
in
{
  # Symlink the theme's chrome CSS directory
  home.activation.firefox-user-chrome = ''
    ln -sfT ${theme-dir.outPath} ${firefoxConfigPath}/${profileName}/chrome
  '';
  programs.firefox = {
    enable = true;
    profiles.${profileName} = {
      id = 0;
      extraConfig = builtins.readFile user-js;
      name = "Default";
      search = {
        default = "ddg";
        force = true;
        order = [
          "ddg"
          "Brave Search"
          "Nix Packages"
          "Nix Options"
          "NixOS Wiki"
          "ChatGPT"
          "Claude"
        ];
        engines = {
          "Brave Search" = {
            urls = [
              {
                template = "https://search.brave.com/search";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = "https://cdn.search.brave.com/serp/v1/static/brand/eebf5f2ce06b0b0ee6bbd72d7e18621d4618b9663471d42463c692d019068072-brave-lion-favicon.png";
            updateInterval = 24 * 60 * 60 * 1000; # every day
            definedAliases = [ "@b" ];
          };
          "ddg".metaData.alias = "@d";
          "Nix Packages" = {
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "channel";
                    value = "unstable";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };
          "Nix Options" = {
            urls = [
              {
                template = "https://search.nixos.org/options";
                params = [
                  {
                    name = "type";
                    value = "options";
                  }
                  {
                    name = "channel";
                    value = "unstable";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@no" ];
          };
          "NixOS Wiki" = {
            urls = [ { template = "https://wiki.nixos.org/w/index.php?search={searchTerms}"; } ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@nw" ];
          };
          "ChatGPT" = {
            urls = [ { template = "https://chatgpt.com/?q={searchTerms}"; } ];
            icon = "https://cdn.oaistatic.com/assets/favicon-dark-32x32-gt5kfzyp.webp";
            updateInterval = 24 * 60 * 60 * 1000;
            definedAliases = [
              "@c"
              "@chatgpt"
            ];
          };
          "Claude" = {
            urls = [ { template = "https://claude.ai/new?q={searchTerms}"; } ];
            icon = "https://claude.ai/favicon.ico";
            updateInterval = 24 * 60 * 60 * 1000;
            definedAliases = [
              "@cl"
              "@claude"
            ];
          };
          # Unwanted search engines
          "Amazon".metaData.hidden = true;
          "Amazon.nl".metaData.hidden = true;
          "ebay".metaData.hidden = true;
        };
      };
      # See ArkenFox: https://github.com/arkenfox/user.js/blob/master/user.js
      settings = {
        # startup debloat
        "browser.newtabpage.enabled" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.activity-stream.default.sites" = "";
        # more debloat
        "extensions.getAddons.showPane" = false;
        "extensions.htmlaboutaddons.recommendations.enabled" = false;
        "browser.discovery.enabled" = false;
        "browser.shopping.experience2023.enabled" = false;
        # disable telemetry, studies, crash reports
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;
        "app.shield.optoutstudies.enabled" = false;
        "app.normandy.first_run" = false;
        "app.normandy.enabled" = false;
        "app.normandy.api_url" = "";
        "breakpad.reportURL" = "";
        "browser.tabs.crashReporting.sendReport" = false;
        # disable FormFill
        "browser.formfill.enable" = false;
        # disable password manager
        "signon.rememberSignons" = false;
        # disable Pocket
        "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
        "extensions.pocket.enabled" = false;
        "extensions.pocket.api" = "";
        "extensions.pocket.oAuthConsumerKey" = "";
        "extensions.pocket.showHome" = false;
        "extensions.pocket.site" = "";
        # Privacy
        "browser.contentblocking.category" = "strict";
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "privacy.partition.network_state.ocsp_cache" = true;
        "privacy.partition.serviceWorkers" = true;
        "privacy.partition.always_partition_third_party_non_cookie_storage" = true;
        "privacy.partition.always_partition_third_party_non_cookie_storage.exempt_sessionstorage" = false;
        # compact mode
        "browser.compactmode.show" = true;
        # strict headers
        "network.http.referer.XOriginPolicy" = 2;
        "network.http.referer.XOriginTrimmingPolicy" = 2;
        # disable captive portal
        "captivedetect.canonicalURL" = "";
        "network.captive-portal-service.enabled" = false;
        "network.connectivity-service.enabled" = false;
        # download dir
        "browser.download.useDownloadDir" = true;
        # dark theme
        "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
      };
    };
  };
}
