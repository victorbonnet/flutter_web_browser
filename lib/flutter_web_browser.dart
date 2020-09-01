import 'dart:async';

import 'package:flutter/services.dart';

class FlutterWebBrowser {
  static const MethodChannel _channel =
      const MethodChannel('flutter_web_browser');

  static Future<dynamic> openWebPage({url, toolbarColor, iosControlColor}) {
    var toolbarHexColor;
    var iosControlHexColor;
    if (toolbarColor != null) {
      toolbarHexColor =
          '#' + toolbarColor.value.toRadixString(16).padLeft(8, '0');
    }
    if (iosControlColor != null) {
      iosControlHexColor =
          '#' + iosControlColor.value.toRadixString(16).padLeft(8, '0');
    }

    return _channel.invokeMethod('openWebPage', {
      "url": url,
      "toolbar_color": toolbarHexColor,
      "ios_control_color": iosControlHexColor
    });
  }
}
