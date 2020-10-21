import 'dart:async';
import 'dart:ui';

import 'package:flutter/services.dart';

enum SafariViewControllerDismissButtonStyle {
  done,
  close,
  cancel,
}

class SafariViewControllerOptions {
  final bool barCollapsingEnabled;
  final bool entersReaderIfAvailable;
  final Color preferredBarTintColor;
  final Color preferredControlTintColor;
  final bool modalPresentationCapturesStatusBarAppearance;
  final SafariViewControllerDismissButtonStyle dismissButtonStyle;

  const SafariViewControllerOptions({
    this.barCollapsingEnabled = false,
    this.entersReaderIfAvailable = false,
    this.preferredBarTintColor,
    this.preferredControlTintColor,
    this.modalPresentationCapturesStatusBarAppearance = false,
    this.dismissButtonStyle,
  });
}

extension _hexColor on Color {
  /// Returns the color value as ARGB hex value.
  String get hexColor {
    return '#' + value.toRadixString(16).padLeft(8, '0');
  }
}

class FlutterWebBrowser {
  static const MethodChannel _channel =
      const MethodChannel('flutter_web_browser');

  static Future<bool> warmup() {
    return _channel.invokeMethod<bool>('warmup');
  }

  static Future<dynamic> openWebPage({
    String url,
    Color androidToolbarColor,
    SafariViewControllerOptions safariVCOptions =
        const SafariViewControllerOptions(),
  }) {
    assert(url != null);
    assert(safariVCOptions != null);

    var hexColor;
    if (androidToolbarColor != null) {
      hexColor = androidToolbarColor?.hexColor;
    }

    return _channel.invokeMethod('openWebPage', {
      "url": url,
      "android_toolbar_color": hexColor,
      'ios_options': {
        'barCollapsingEnabled': safariVCOptions.barCollapsingEnabled,
        'entersReaderIfAvailable': safariVCOptions.entersReaderIfAvailable,
        'preferredBarTintColor':
            safariVCOptions.preferredBarTintColor?.hexColor,
        'preferredControlTintColor':
            safariVCOptions.preferredControlTintColor?.hexColor,
        'modalPresentationCapturesStatusBarAppearance':
            safariVCOptions.modalPresentationCapturesStatusBarAppearance,
        'dismissButtonStyle': safariVCOptions.dismissButtonStyle?.index,
      },
    });
  }
}
