package dev.vbonnet.flutterwebbrowser;

import android.app.Activity;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;

/** FlutterWebBrowserPlugin */
public class FlutterWebBrowserPlugin implements FlutterPlugin, ActivityAware {

  private MethodChannel methodChannel;
  private MethodCallHandlerImpl methodCallHandler;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
    startListening(binding.getBinaryMessenger());
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    stopListening();
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    setActivity(binding.getActivity());
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    setActivity(null);
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    setActivity(binding.getActivity());
  }

  @Override
  public void onDetachedFromActivity() {
    setActivity(null);
  }

  private void startListening(BinaryMessenger messenger) {
    methodChannel = new MethodChannel(messenger, "flutter_web_browser");
    methodCallHandler = new MethodCallHandlerImpl();
    methodChannel.setMethodCallHandler(methodCallHandler);
  }

  private void setActivity(@Nullable Activity activity) {
    methodCallHandler.setActivity(activity);
  }

  private void stopListening() {
    methodChannel.setMethodCallHandler(null);
    methodChannel = null;
  }
}
