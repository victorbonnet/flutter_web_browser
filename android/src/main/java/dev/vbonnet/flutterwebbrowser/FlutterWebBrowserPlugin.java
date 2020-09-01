package dev.vbonnet.flutterwebbrowser;

import android.app.Activity;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.plugin.common.PluginRegistry.ViewDestroyListener;
import io.flutter.view.FlutterNativeView;

/** FlutterWebBrowserPlugin */
public class FlutterWebBrowserPlugin implements FlutterPlugin, ActivityAware {

  private MethodChannel methodChannel;
  private MethodCallHandlerImpl methodCallHandler;

  public static void registerWith(Registrar registrar) {
    final FlutterWebBrowserPlugin plugin = new FlutterWebBrowserPlugin();
    plugin.startListening(registrar.messenger());
    if (registrar.activity() != null) {
      plugin.setActivity(registrar.activity());
    }
    registrar.addViewDestroyListener(
        new ViewDestroyListener() {
          @Override
          public boolean onViewDestroy(FlutterNativeView view) {
            plugin.stopListening();
            return false;
          }
        });
  }

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
