{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.richard.browser.http;
in {
  options.richard.browser.http.firefox = {
    enable = mkOption {
      description = "Enable firefox";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.firefox.enable) {
    home.sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
      MOZ_USE_XINPUT2 = "1";
    };
    programs = {
      browserpass = {
        enable = true;
        browsers = ["firefox"];
      };
      firefox = {
        enable = true;
        package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
          extraPolicies = {
            ExtensionSettings = {};
          };
        };
        profiles = {
          richard = {
            id = 0;
            isDefault = true;
            extensions = with pkgs.nur.repos.rycee.firefox-addons; [
              betterttv
              browserpass
              bypass-paywalls-clean
              clearurls
              cookie-autodelete
              darkreader
              decentraleyes
              firefox-color
              honey
              ublock-origin
              vimium-c
            ];
            settings = let
              browser = let
                activityStream = "browser.newtabpage.activity-stream";
              in {
                "browser.aboutConfig.showWarning" = false;
                "${activityStream}.enabled" = false;
                "${activityStream}.feeds.topsites" = false;
                "${activityStream}.newtabpage.showSearch" = true;
                "${activityStream}.newtabpage.showSponsoredTopSites" = false;
                "${activityStream}.newtabpage.showSponsorsed" = false;
                "${activityStream}.feeds.discoverystreamfeed" = false;
                "${activityStream}.feeds.section.highlights" = false;
                "${activityStream}.feeds.section.topstories" = false;
                "${activityStream}.section.highlights.includeBookmarks" = false;
                "${activityStream}.section.highlights.includeDownloads" = false;
                "${activityStream}.section.highlights.includePocket" = false;
                "${activityStream}.section.highlights.includeVisited" = false;
                "${activityStream}.telemetry" = false;
                "${activityStream}.feeds.telemetry" = false;
                "browser.bookmarks.addedImportButton" = false;
                "browser.bookmarks.restore_default_bookmarks" = false;
                "browser.download.useDownloadDir" = false;
                "browser.download.viewableInternally.typeWasRegistered.avif" = true;
                "browser.download.viewableInternally.typeWasRegistered.webp" = true;
                "browser.fullscreen.autohide" = false;
                "browser.ping-centre.telemetry" = false;
                "browser.shell.checkDefaultBrowser" = false;
                "browser.tabs.crashReporting.sendReport" = false;
                "browser.toolbars.bookmarks.visibility" = "newtab";
                "browser.urlbar.showSearchSuggestionsFirst" = true;
                "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
                "browser.urlbar.suggest.quicksuggest.sponsored" = false;
                "browser.search.suggest.enabled" = false;
                "browser.startup.couldRestoreSession.count" = 2;
                "browser.startup.page" = 3;
                "browser.startup.homepage" = "/home/richard/.dotfiles/modules/users/browser/start/index.html";
              };

              extensions = {
                "extensions.formautofill.addresses.enabled" = false;
                "extensions.htmlaboutaddons.inline-options.enabled" = false;
                "extensions.htmlaboutaddons.recommendations.enabled" = false;
                "extensions.pocket.enabled" = false;
              };

              telemetry = let
                telemetry = "toolkit.telemetry";
              in {
                "app.shield.optoutstudies.enabled" = false;
                "datareporting.healthreport.uploadEnabled" = false;
                "datareporting.policy.dataSubmissionEnabled" = false;
                "devtools.onboarding.telemetry.logged" = false;
                "${telemetry}.enabled" = false;
                "${telemetry}.server" = "";
                "${telemetry}.unified" = false;
                "${telemetry}.reportingpolicy.firstRun" = false;
                "${telemetry}.archive.enabled" = false;
                "${telemetry}.updatePing.enabled" = false;
                "${telemetry}.shutdownPingSender.enabled" = false;
                "${telemetry}.newProfilePing.enabled" = false;
                "${telemetry}.bhrPing.enabled" = false;
                "${telemetry}.firstShutdownPing.enabled" = false;
              };

              misc = {
                "geo.enabled" = false;
                "network.dns.disablePrefetch" = true;
                "network.prefetch-next" = false;
                "pdfjs.enableScripting" = false;
                "widget.use-xdg-desktop-portal.file-picker" = 2;
                "widget.use-xdg-desktop-portal.mime-handler" = 2;
                "intl.accept_languages" = "en_GB,en";
                "intl.regional_prefs.use_os_locales" = true;
              };

              dom = {
                # "dom.event.clipboardevents.enabled" = false; # Breaks copy/paste on websites
                "dom.battery.enabled" = false;
                "dom.forms.autocomplete.formautofill" = false;
                "dom.security.https_only_mode" = true;
                "dom.security.https_only_mode_ever_enabled" = true;
                "dom.webnotifications.enabled" = false;
                "ui.systemUsesDarkTheme" = 1;
              };

              font = {
                "font.size.variable.x-western" = 18;
                "font.size.monospace.x-western" = 14;
              };

              # webrtc = {
              #   "media.peerconnection.enabled" = false;
              #   "media.navigator.enabled" = false;
              # };

              # webgl = {
              #   "webgl.disabled" = true;
              # };

              # fingerprinting = {
              #   "privacy.resistFingerprinting" = true;
              # };

              # cookies = {
              #   "privacy.firstparty.isolate" = true;
              #   "network.cookie.lifetimePolicy" = "2";
              # };

              graphics = {
                "media.ffmpeg.vaapi.enabled" = true;
                "media.rdd-ffmpeg.enabled" = true;
                "media.navigator.medidataencoder_vpx_enabled" = true;
              };

              passwords = {
                "signon.rememberSignons" = false;
                "signon.autofillForms" = false;
                "signon.generation.enabled" = false;
                "signon.management.page.breach-alerts.enabled" = false;
              };
            in
              browser // extensions // telemetry // misc // dom // font // graphics // passwords;
            # extraConfig = ""; # user.js
            # userChrome = ""; # User chrome css
            # userContent = ""; # User content css
            # bookmarks = [ ]; # imports = [ ~/.dotfiles/secrets/firefox ];
          };
        };
      };
    };
  };
}
