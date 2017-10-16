import 'dart:async';

import 'package:flutter/services.dart';

class FlutterWebBrowser {
  static const MethodChannel _channel =
      const MethodChannel('flutter_web_browser');

  static Future<Null> openWebPage({url, androidToolbarColor}) {
    return _channel.invokeMethod('openWebPage', {
      "url": url,
      "android_toolbar_color": androidToolbarColor,
    });
  }

}
