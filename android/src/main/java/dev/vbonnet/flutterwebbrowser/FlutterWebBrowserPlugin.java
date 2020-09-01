package dev.vbonnet.flutterwebbrowser;

import android.app.Activity;
import android.graphics.Color;
import android.net.Uri;
import androidx.browser.customtabs.CustomTabsIntent;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * FlutterWebBrowserPlugin
 */
public class FlutterWebBrowserPlugin implements MethodCallHandler {

  private Activity activity;

  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_web_browser");
    channel.setMethodCallHandler(new FlutterWebBrowserPlugin(registrar.activity()));
  }

  private FlutterWebBrowserPlugin(Activity activity) {
        this.activity = activity;
    }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    switch (call.method) {
      case "openWebPage":
         openUrl(call, result);
         break;
      default:
        result.notImplemented();
        break;
    }
  }

    private void openUrl(MethodCall call, Result result) {
      String url = call.argument("url");
      String toolbarColorArg = call.argument("toolbar_color");

      CustomTabsIntent.Builder builder = new CustomTabsIntent.Builder();
      if (toolbarColorArg != null) {
        int toolbarColor = Color.parseColor(toolbarColorArg);
        builder.setToolbarColor(toolbarColor);
      }
      CustomTabsIntent customTabsIntent = builder.build();
      customTabsIntent.launchUrl(activity, Uri.parse(url));
    }
}
