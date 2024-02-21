{ inputs, outputs, lib, config, pkgs, ... }:
let
  # Lepton theme https://github.com/black7375/Firefox-UI-Fix
  theme-dir = builtins.fetchGit {
    url = "https://github.com/black7375/Firefox-UI-Fix.git";
    rev = "d91f2822b4b9f71d6fc7f7d870526fcf56719348"; # must be updated for newer versions
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
          "DuckDuckGo".metaData.alias = "@d";
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
          # Unwanted search engines
          "Amazon".metaData.hidden = true;
          "Amazon.nl".metaData.hidden = true;
          "eBay".metaData.hidden = true;
        };
      };
      # See ArkenFox: https://github.com/arkenfox/user.js/blob/master/user.js
      settings = {
        "browser.newtabpage.enabled" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
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
        # The tems that are selected automatically when you bring up the Clear Browsing Data dialog
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
