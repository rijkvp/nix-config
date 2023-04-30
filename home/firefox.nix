{ inputs, outputs, lib, config, pkgs, ... }: {
    programs.firefox = {
      enable = true;
      profiles.default = {
        id = 0;
        name = "Default";
        search = {
          default = "Brave Search";
          force = true;
          order = [
            "Brave Search"
            "DuckDuckGo"
            "Nix Packages"
            "Nix Options"
            "NixOS Wiki"
          ];
          engines = {
            "Brave Search" = {
              urls = [{
                template = "https://search.brave.com/search";
                params = [
                  { name = "q"; value = "{searchTerms}"; }
                ];
              }];
              iconUpdateURL = "https://cdn.search.brave.com/serp/v1/static/brand/eebf5f2ce06b0b0ee6bbd72d7e18621d4618b9663471d42463c692d019068072-brave-lion-favicon.png";
              updateInterval = 24 * 60 * 60 * 1000; # every day
              definedAliases = [ "@b" ];
            };
            "Nix Packages" = {
                urls = [{
                  template = "https://search.nixos.org/packages";
                  params = [
                    { name = "type"; value = "packages"; }
                    { name = "channel"; value = "unstable"; }
                    { name = "query"; value = "{searchTerms}"; }
                  ];
                }];
                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@np" ];
              };
              "Nix Options" = {
                urls = [{
                  template = "https://search.nixos.org/options";
                  params = [
                    { name = "type"; value = "options"; }
                    { name = "channel"; value = "unstable"; }
                    { name = "query"; value = "{searchTerms}"; }
                  ];
                }];
                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@no" ];
              };
              "NixOS Wiki" = {
                urls = [{ template = "https://nixos.wiki/index.php?search={searchTerms}"; }];
                iconUpdateURL = "https://nixos.wiki/favicon.png";
                updateInterval = 24 * 60 * 60 * 1000; # every day
                definedAliases = [ "@nw" ];
              };
            "DuckDuckGo".metaData.alias = "@d";
            "Bing".metaData.hidden = true;
            "Amazon".metaData.hidden = true;
            "Amazon.nl".metaData.hidden = true;
            "Google".metaData.hidden = true;
            "eBay".metaData.hidden = true;
          };
        };
        # See ArkenFox: https://github.com/arkenfox/user.js/blob/master/user.js
        settings = {
          # Startup/home
          "browser.startup.homepage" = "http://home.local";
          "browser.startup.page" = 1;
          "browser.newtabpage.enabled" = false;
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "browser.newtabpage.activity-stream.default.sites" = "http://home.local";
          # Disable telemetery
          "datareporting.policy.dataSubmissionEnabled" = false;
          "datareporting.healthreport.uploadEnabled" = false;
          "toolkit.telemetry.unified" = false;
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.server" = "data:,";
          "toolkit.telemetry.archive.enabled" = false;
          "toolkit.telemetry.newProfilePing.enabled" = false;
          "toolkit.telemetry.shutdownPingSender.enabled" = false;
          "toolkit.telemetry.updatePing.enabled" = false;
          "toolkit.telemetry.bhrPing.enabled" = false; 
          "toolkit.telemetry.firstShutdownPing.enabled" = false; 
          "toolkit.telemetry.coverage.opt-out" = true; 
          "toolkit.telemetry.hybridContent.enabled" = false;
          "toolkit.telemetry.reportingpolicy.firstRun" = false;
          "toolkit.coverage.opt-out" = true; 
          "toolkit.coverage.endpoint.base" = "";
          "browser.ping-centre.telemetry" = false;
          "browser.newtabpage.activity-stream.feeds.telemetry" = false;
          "browser.newtabpage.activity-stream.telemetry" = false;
          "app.shield.optoutstudies.enabled" = false;
          "app.normandy.enabled" = false;
          "app.normandy.api_url" = "";
          "breakpad.reportURL" = "";
          "browser.tabs.crashReporting.sendReport" = false; 
          "browser.crashReports.unsubmittedCheck.enabled" = false; 
          "browser.crashReports.unsubmittedCheck.autoSubmit2" = false; 
          "captivedetect.canonicalURL" = "";
          "network.captive-portal-service.enabled" = false;
          "network.connectivity-service.enabled" = false;
          # Disable experiments
          "experiments.activeExperiment" = false;
          "experiments.enabled" = false;
          "experiments.supported" = false;
          "network.allow-experiments" = false;
          # Disable FormFill
          "browser.formfill.enable" = false;
          # Don't ask for saving passwords
          "signon.rememberSignons" = false;
          # Disable Pocket
          "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
          "extensions.pocket.enabled" = false;
          "extensions.pocket.api" = "";
          "extensions.pocket.oAuthConsumerKey" = "";
          "extensions.pocket.showHome" = false;
          "extensions.pocket.site" = "";
          # Hide 'Firefox View'
          "browser.tabs.firefox-view" = false;
          # Compact mode
          "browser.compactmode.show" = true;
          # Strict headers
          "network.http.referer.XOriginPolicy" = 2;
          "network.http.referer.XOriginTrimmingPolicy" = 2;
          # Privacy
          "browser.contentblocking.category" = "strict";
          "privacy.trackingprotection.enabled" = true;
          "privacy.trackingprotection.socialtracking.enabled" = true;
          "privacy.partition.network_state.ocsp_cache" = true;
          "privacy.partition.serviceWorkers" = true;
          "privacy.partition.always_partition_third_party_non_cookie_storage" = true;
          "privacy.partition.always_partition_third_party_non_cookie_storage.exempt_sessionstorage" = false;
          # Clear cookies on shutdown, add exception for ther sizes
          "privacy.sanitize.sanitizeOnShutdown" = true;
          "privacy.clearOnShutdown.cache" = true;
          "privacy.clearOnShutdown.downloads" = true;
          "privacy.clearOnShutdown.formdata" = true;
          "privacy.clearOnShutdown.history" = true;
          "privacy.clearOnShutdown.sessions" = true; # only HTTP basic auth
          "privacy.clearOnShutdown.cookies" = true; # logs out of sites
          "privacy.clearOnShutdown.offlineApps" = true;
          "privacy.cpd.cache" = true;   
          "privacy.cpd.formdata" = true;
          "privacy.cpd.history" = true;
          "privacy.cpd.sessions" = true;
          "privacy.cpd.offlineApps" = false;
          "privacy.cpd.cookies" = false;
          # Dark theme
          "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
        };
      };
    };
}
