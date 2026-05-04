{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

{
  programs.firefox = {
    enable = true;

    profiles.yes = {
      isDefault = true;

      extensions.packages = with inputs.firefox-addons.packages."x86_64-linux"; [
        ublock-origin
        sponsorblock
        darkreader
        youtube-shorts-block
      ];

      # Arkenfox (Read from a local file)
      extraConfig = builtins.readFile ./arkenfox.js;

      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

        "privacy.resistFingerprinting" = false;
        "privacy.resistFingerprinting.letterboxing" = false;

        "network.cookie.lifetimePolicy" = 0;

        # Force dark color scheme for content
        "layout.css.prefers-color-scheme.content-override" = 0;

        # Dark background for pages that haven't loaded yet
        "browser.display.background_color" = "#282828";
        "browser.display.foreground_color" = "#ebdbb2";
        "browser.display.use_system_colors" = false;

        # Tell Firefox the system uses dark theme
        "ui.systemUsesDarkTheme" = 1;

        # Prevent white flash before page load
        "browser.startup.blankWindow" = false;

        # Use XDG portal for file picker (fixes black screen on Hyprland/Wayland)
        "widget.use-xdg-desktop-portal.file-picker" = 1;
      };

      userChrome = ''
        /* ── Gruvbox Dark – Firefox userChrome ── */

        :root {
          --gb-bg:     #282828;
          --gb-bg1:    #3c3836;
          --gb-bg2:    #504945;
          --gb-bg3:    #665c54;
          --gb-fg:     #ebdbb2;
          --gb-fg4:    #a89984;
          --gb-green:  #b8bb26;

          /* Override Firefox LWT variables */
          --toolbar-bgcolor:                  var(--gb-bg)    !important;
          --toolbar-color:                    var(--gb-fg)    !important;
          --toolbar-field-background-color:   var(--gb-bg1)   !important;
          --toolbar-field-color:              var(--gb-fg)    !important;
          --toolbar-field-border-color:       var(--gb-bg2)   !important;
          --toolbar-field-focus-background-color: var(--gb-bg1) !important;
          --toolbar-field-focus-border-color: var(--gb-green) !important;
          --lwt-text-color:                   var(--gb-fg)    !important;
          --lwt-tab-text:                     var(--gb-fg)    !important;
          --button-bgcolor:                   var(--gb-bg1)   !important;
          --button-hover-bgcolor:             var(--gb-bg2)   !important;
          --button-active-bgcolor:            var(--gb-bg3)   !important;
          --button-color:                     var(--gb-fg)    !important;
          --urlbar-box-bgcolor:               var(--gb-bg1)   !important;
          --urlbar-box-focus-bgcolor:         var(--gb-bg1)   !important;
          --tab-selected-bgcolor:             var(--gb-bg2)   !important;
          --chrome-content-separator-color:   var(--gb-bg1)   !important;
          background-color:                   var(--gb-bg)    !important;

          /* Popup panel variables (controls ALL popups globally) */
          --arrowpanel-background:                    var(--gb-bg)    !important;
          --arrowpanel-color:                         var(--gb-fg)    !important;
          --arrowpanel-border-color:                  var(--gb-bg2)   !important;
          --panel-background:                         var(--gb-bg)    !important;
          --panel-color:                              var(--gb-fg)    !important;
          --panel-border-color:                       var(--gb-bg2)   !important;

          /* Autocomplete popup */
          --autocomplete-popup-background:            var(--gb-bg)    !important;
          --autocomplete-popup-color:                 var(--gb-fg)    !important;
          --autocomplete-popup-highlight-background:  var(--gb-bg2)   !important;
          --autocomplete-popup-highlight-color:       var(--gb-fg)    !important;
          --urlbar-popup-url-color:                   var(--gb-fg4)   !important;
          --urlbar-popup-action-color:                var(--gb-green) !important;

          /* Content area background */
          --tabpanel-background-color:                var(--gb-bg)    !important;
        }

        /* ── Window containers (prevent white border bleed) ── */
        #main-window,
        #browser,
        #tabbrowser-tabpanels,
        #appcontent {
          background-color: var(--gb-bg) !important;
        }

        /* ── Toolbars ── */
        #navigator-toolbox,
        #nav-bar,
        #TabsToolbar,
        #PersonalToolbar {
          background-color: var(--gb-bg) !important;
          color: var(--gb-fg) !important;
          border-color: var(--gb-bg1) !important;
        }
        #navigator-toolbox {
          border-bottom: none !important;
        }
        #navigator-toolbox::after {
          border-bottom: none !important;
        }
        #nav-bar {
          box-shadow: none !important;
          border-top: 1px solid var(--gb-bg1) !important;
        }
        #TabsToolbar {
          border-top: none !important;
          box-shadow: none !important;
        }

        /* ── URL Bar ── */
        #urlbar-background,
        #urlbar:not([focused]) > #urlbar-background {
          background-color: var(--gb-bg1) !important;
          border: 1px solid var(--gb-bg2) !important;
          box-shadow: none !important;
        }
        #urlbar:focus-within #urlbar-background,
        #urlbar[focused] > #urlbar-background {
          background-color: var(--gb-bg1) !important;
          border-color: var(--gb-green) !important;
          box-shadow: 0 0 0 1px var(--gb-green) !important;
        }
        #urlbar-input,
        .urlbar-input {
          color: var(--gb-fg) !important;
        }

        /* ── URL bar autocomplete dropdown ── */
        .urlbarView {
          background-color: var(--gb-bg1) !important;
          color: var(--gb-fg) !important;
          border-color: var(--gb-bg2) !important;
        }
        .urlbarView-body-inner {
          background-color: var(--gb-bg1) !important;
        }
        .urlbarView-row {
          background-color: var(--gb-bg1) !important;
          color: var(--gb-fg) !important;
        }
        .urlbarView-row:hover,
        .urlbarView-row[selected] {
          background-color: var(--gb-bg2) !important;
        }
        .urlbarView-row-inner {
          background-color: transparent !important;
        }
        .urlbarView-title {
          color: var(--gb-fg) !important;
        }
        .urlbarView-url,
        .urlbarView-action {
          color: var(--gb-fg4) !important;
        }
        .urlbarView-row[type="tip"],
        .urlbarView-row[type="dynamic"] {
          background-color: var(--gb-bg) !important;
        }

        /* Search one-off buttons */
        .search-one-offs {
          background-color: var(--gb-bg1) !important;
          border-top: 1px solid var(--gb-bg2) !important;
        }
        .searchbar-engine-one-off-item {
          background-color: var(--gb-bg1) !important;
          color: var(--gb-fg) !important;
        }
        .searchbar-engine-one-off-item:hover {
          background-color: var(--gb-bg2) !important;
        }

        /* ── Tabs ── */
        .tabbrowser-tab .tab-background {
          background-color: transparent !important;
          background-image: none !important;
          box-shadow: none !important;
        }
        .tabbrowser-tab:hover .tab-background {
          background-color: var(--gb-bg1) !important;
        }
        .tabbrowser-tab[selected] .tab-background,
        .tabbrowser-tab[multiselected] .tab-background {
          background-color: var(--gb-bg2) !important;
          background-image: none !important;
        }
        .tabbrowser-tab .tab-label {
          color: var(--gb-fg4) !important;
        }
        .tabbrowser-tab[selected] .tab-label,
        .tabbrowser-tab[multiselected] .tab-label {
          color: var(--gb-fg) !important;
        }

        /* Tab indicator line */
        .tab-line {
          display: none !important;
        }

        /* ── Toolbar Buttons ── */
        .toolbarbutton-1 {
          color: var(--gb-fg) !important;
          border-radius: 4px !important;
        }
        .toolbarbutton-1:hover {
          background-color: var(--gb-bg1) !important;
        }
        .toolbarbutton-1[open],
        .toolbarbutton-1:active {
          background-color: var(--gb-bg2) !important;
        }

        /* ── Sidebar ── */
        #sidebar-box {
          background-color: var(--gb-bg) !important;
          color: var(--gb-fg) !important;
        }

        /* ── Window background ── */
        browser {
          background-color: var(--gb-bg) !important;
        }

        /* ── All popup panels (hamburger menu, downloads, permissions, etc.) ── */
        panel,
        menupopup,
        .panel-arrowcontent,
        panelview,
        #appMenu-popup,
        #customizationui-widget-panel,
        #widget-overflow {
          background-color: var(--gb-bg) !important;
          color: var(--gb-fg) !important;
          border-color: var(--gb-bg2) !important;
        }
        panel .panel-arrowcontent {
          background-color: var(--gb-bg) !important;
          color: var(--gb-fg) !important;
          border: 1px solid var(--gb-bg2) !important;
        }

        /* Popup menu items */
        menuitem,
        menu,
        menupopup > menuitem,
        menupopup > menu {
          color: var(--gb-fg) !important;
        }
        menuitem:hover,
        menu:hover,
        menuitem[_moz-menuactive="true"],
        menu[_moz-menuactive="true"] {
          background-color: var(--gb-bg2) !important;
          color: var(--gb-fg) !important;
        }
        menuseparator {
          border-color: var(--gb-bg2) !important;
        }
        .menu-text,
        .menu-iconic-text,
        .menuitem-text {
          color: var(--gb-fg) !important;
        }

        /* ── Downloads panel ── */
        #downloadsPanel,
        #downloadsListBox,
        #downloadsPanel-mainView,
        #downloadsPanel-multiView {
          background-color: var(--gb-bg) !important;
          color: var(--gb-fg) !important;
        }
        #downloadsListBox .downloadMainArea {
          background-color: var(--gb-bg) !important;
          color: var(--gb-fg) !important;
        }
        #downloadsListBox richlistitem:hover {
          background-color: var(--gb-bg1) !important;
        }
        #downloadsListBox richlistitem[selected] {
          background-color: var(--gb-bg2) !important;
        }
        .downloadTarget {
          color: var(--gb-fg) !important;
        }
        .downloadDetails,
        .downloadDetailsNormal {
          color: var(--gb-fg4) !important;
        }
        #downloadsPanel button,
        #downloadsPanel toolbarbutton {
          color: var(--gb-fg) !important;
          background-color: var(--gb-bg1) !important;
        }
        #downloadsPanel button:hover,
        #downloadsPanel toolbarbutton:hover {
          background-color: var(--gb-bg2) !important;
        }

        /* ── Tooltip ── */
        tooltip {
          background-color: var(--gb-bg1) !important;
          color: var(--gb-fg) !important;
          border: 1px solid var(--gb-bg2) !important;
          -moz-appearance: none !important;
          appearance: none !important;
        }

        /* ── Panel header/footer ── */
        .panel-footer,
        .panel-header {
          background-color: var(--gb-bg1) !important;
          color: var(--gb-fg) !important;
          border-color: var(--gb-bg2) !important;
        }

        /* ── Notification popups ── */
        .popup-notification-body,
        popupnotification,
        .popup-notification-description {
          color: var(--gb-fg) !important;
        }

        /* ── Findbar ── */
        .browserContainer > findbar {
          background-color: var(--gb-bg1) !important;
          color: var(--gb-fg) !important;
          border-top: 1px solid var(--gb-bg2) !important;
        }
        .findbar-textbox {
          background-color: var(--gb-bg) !important;
          color: var(--gb-fg) !important;
          border: 1px solid var(--gb-bg2) !important;
        }
      '';

      userContent = ''
        /* ── about:blank and loading pages ── */
        @-moz-document url("about:blank"), url("about:privatebrowsing") {
          :root, html, body {
            background-color: #282828 !important;
            color: #ebdbb2 !important;
          }
        }

        /* ── New Tab / Home (Activity Stream) ── */
        @-moz-document url("about:newtab"), url("about:home") {
          :root {
            --newtab-background-color: #282828 !important;
            --newtab-background-color-secondary: #3c3836 !important;
            --newtab-text-primary-color: #ebdbb2 !important;
            --newtab-primary-action-background: #504945 !important;
            --newtab-element-hover-color: #3c3836 !important;
            --newtab-element-active-color: #504945 !important;
            --newtab-border-color: #504945 !important;
            --newtab-search-border-color: #504945 !important;
            --newtab-search-icon-color: #a89984 !important;
            --newtab-card-background-color: #3c3836 !important;
            --newtab-card-shadow: 0 1px 4px rgba(0, 0, 0, 0.5) !important;
            --newtab-snippets-background-color: #3c3836 !important;
            --newtab-section-header-text-color: #ebdbb2 !important;
            --newtab-topsites-background-color: #3c3836 !important;
            --newtab-topsites-label-color: #a89984 !important;
            color-scheme: dark !important;
          }

          html, body,
          body.activity-stream,
          .activity-stream {
            background-color: #282828 !important;
            color: #ebdbb2 !important;
          }

          .outer-wrapper,
          .body-wrapper,
          main {
            background-color: #282828 !important;
          }

          /* Search box */
          .search-wrapper input,
          .search-handoff-button,
          .search-wrapper .search-inner-wrapper {
            background-color: #3c3836 !important;
            color: #ebdbb2 !important;
            border: 1px solid #504945 !important;
          }

          /* Top Sites tiles */
          .top-site-outer .tile,
          .top-sites-list .top-site-outer {
            background-color: #3c3836 !important;
            color: #ebdbb2 !important;
          }
          .top-site-outer:hover .tile {
            background-color: #504945 !important;
          }

          /* Section titles */
          .section-title span,
          .section-title .section-title-text {
            color: #ebdbb2 !important;
          }

          /* Cards (Highlights, Pocket) */
          .card-outer,
          .card-outer .card {
            background-color: #3c3836 !important;
            color: #ebdbb2 !important;
          }
          .card-outer:hover {
            background-color: #504945 !important;
          }
          .card-outer .card-title,
          .card-outer .card-host-name {
            color: #ebdbb2 !important;
          }

          /* Context menus in new tab */
          .context-menu,
          .context-menu-list {
            background-color: #3c3836 !important;
            border: 1px solid #504945 !important;
          }
          .context-menu-item {
            color: #ebdbb2 !important;
          }
          .context-menu-item:hover {
            background-color: #504945 !important;
          }
        }

        /* ── about: pages (preferences, addons, etc.) ── */
        @-moz-document url-prefix("about:preferences"),
                        url-prefix("about:addons"),
                        url-prefix("about:config"),
                        url-prefix("about:downloads"),
                        url-prefix("about:debugging"),
                        url-prefix("about:devtools"),
                        url-prefix("about:certificate"),
                        url-prefix("about:support"),
                        url-prefix("about:memory"),
                        url-prefix("about:networking"),
                        url-prefix("about:performance"),
                        url-prefix("about:processes"),
                        url-prefix("about:protections"),
                        url-prefix("about:rights"),
                        url-prefix("about:serviceworkers"),
                        url-prefix("about:studies"),
                        url-prefix("about:telemetry"),
                        url-prefix("about:welcome"),
                        url-prefix("about:logins") {
          :root, html, body {
            background-color: #282828 !important;
            color: #ebdbb2 !important;
            color-scheme: dark !important;
          }
        }
      '';
    };
  };
}
