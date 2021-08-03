package dev.vbonnet.flutterwebbrowser;

import android.app.Activity;
import android.graphics.Color;
import android.net.Uri;
import androidx.browser.customtabs.CustomTabColorSchemeParams;
import androidx.browser.customtabs.CustomTabsClient;
import androidx.browser.customtabs.CustomTabsIntent;
import java.util.Arrays;
import java.util.HashMap;
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
      case "warmup":
        warmup(result);
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  private void openUrl(MethodCall call, Result result) {
    if (activity == null) {
      result.error("no_activity", "Plugin is only available within an activity context", null);
      return;
    }
    String url = call.argument("url");
    HashMap<String, Object> options = call.<HashMap<String, Object>>argument("android_options");

    CustomTabsIntent.Builder intentBuilder = new CustomTabsIntent.Builder();

    intentBuilder.setColorScheme((Integer) options.get("colorScheme"));

    CustomTabColorSchemeParams.Builder colorSchemeParamsBuilder = new CustomTabColorSchemeParams.Builder();

    String navigationBarColor = (String)options.get("navigationBarColor");
    if (navigationBarColor != null) {
      colorSchemeParamsBuilder.setNavigationBarColor(Color.parseColor(navigationBarColor));
    }

    String toolbarColor = (String)options.get("toolbarColor");
    if (toolbarColor != null) {
      colorSchemeParamsBuilder.setToolbarColor(Color.parseColor(toolbarColor));
    }

    String secondaryToolbarColor = (String)options.get("secondaryToolbarColor");
    if (secondaryToolbarColor != null) {
      colorSchemeParamsBuilder.setSecondaryToolbarColor(Color.parseColor(secondaryToolbarColor));
    }

    CustomTabColorSchemeParams colorSchemeParams = colorSchemeParamsBuilder.build();
    intentBuilder.setDefaultColorSchemeParams(colorSchemeParams);

    intentBuilder.setInstantAppsEnabled((Boolean) options.get("instantAppsEnabled"));

    Integer shareState = (Integer)options.get("shareState");
    if (shareState != null) {
      intentBuilder.setShareState(shareState);
    }

    intentBuilder.setShowTitle((Boolean) options.get("showTitle"));

    intentBuilder.setUrlBarHidingEnabled((Boolean) options.get("urlBarHidingEnabled"));

    CustomTabsIntent customTabsIntent = intentBuilder.build();
    customTabsIntent.intent.setPackage(getPackageName());
    customTabsIntent.launchUrl(activity, Uri.parse(url));

    result.success(null);
  }

  private void warmup(Result result) {
    boolean success = CustomTabsClient.connectAndInitialize(activity, getPackageName());
    result.success(success);
  }

  private String getPackageName() {
    return CustomTabsClient.getPackageName(activity, Arrays.asList("com.android.chrome"));
  }
}
