# flutter_web_browser

[![Pub](https://img.shields.io/pub/v/flutter_web_browser.svg)](https://pub.dartlang.org/packages/flutter_web_browser)

A flutter plugin to open a web page with [Chrome Custom Tabs](https://developer.chrome.com/multidevice/android/customtabs) & [SFSafariViewController](https://developer.apple.com/documentation/safariservices/sfsafariviewcontroller).

This plugin is under development, APIs might change.

## Getting Started

#### Installation
Install the library from pub:
```
dependencies:
  flutter_web_browser: "^0.16.0"
```


#### Import the library
```
import 'package:flutter_web_browser/flutter_web_browser.dart';
```

##### Open the web page
```
FlutterWebBrowser.openWebPage(
  url: "https://flutter.io/",
  customTabsOptions: const CustomTabsOptions(
    colorScheme: CustomTabsColorScheme.dark,
    toolbarColor: Colors.deepPurple,
    secondaryToolbarColor: Colors.green,
    navigationBarColor: Colors.amber,
    shareState: CustomTabsShareState.on,
    instantAppsEnabled: true,
    showTitle: true,
    urlBarHidingEnabled: true,
  ),
  safariVCOptions: const SafariViewControllerOptions(
    barCollapsingEnabled: true,
    preferredBarTintColor: Colors.green,
    preferredControlTintColor: Colors.amber,
    dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
    modalPresentationCapturesStatusBarAppearance: true,
  ),
);
```


## License
This project is licensed under the terms of the MIT license.
