package dev.vbonnet.flutterwebbrowser;

import android.app.Activity;
import android.graphics.Color;
import android.net.Uri;
import androidx.browser.customtabs.CustomTabsClient;
import androidx.browser.customtabs.CustomTabsIntent;
import java.util.Arrays;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class MethodCallHandlerImpl implements MethodCallHandler {

  private Activity activity;

  public void setActivity(Activity activity) {
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
    if (activity == null) {
      result.error("no_activity", "Plugin is only available within a activity context", null);
      return;
    }
    String url = call.argument("url");
    String toolbarColorArg = call.argument("android_toolbar_color");

    CustomTabsIntent.Builder builder = new CustomTabsIntent.Builder();
    if (toolbarColorArg != null) {
      int toolbarColor = Color.parseColor(toolbarColorArg);
      builder.setToolbarColor(toolbarColor);
    }

    CustomTabsIntent customTabsIntent = builder.build();
    String packageName = CustomTabsClient.getPackageName(activity, Arrays.asList("com.android.chrome"));
    customTabsIntent.intent.setPackage(packageName);
    customTabsIntent.launchUrl(activity, Uri.parse(url));

    result.success(null);
  }
}
