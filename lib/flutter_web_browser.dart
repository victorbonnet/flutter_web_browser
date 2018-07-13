import 'dart:async';

import 'package:flutter/services.dart';

class FlutterWebBrowser {
  static const MethodChannel _channel =
      const MethodChannel('flutter_web_browser');

  static Future<dynamic> openWebPage({url, androidToolbarColor}) {
    var hexColor;
    if (androidToolbarColor != null) {
      hexColor = '#'+androidToolbarColor.value.toRadixString(16).padLeft(8, '0');
    }
    return _channel.invokeMethod('openWebPage', {
      "url": url,
      "android_toolbar_color": hexColor,
    });
  }

}
