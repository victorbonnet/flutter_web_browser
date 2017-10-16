#import "FlutterWebBrowserPlugin.h"
#import <SafariServices/SafariServices.h>

@implementation FlutterWebBrowserPlugin 
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_web_browser"
            binaryMessenger:[registrar messenger]];
  FlutterWebBrowserPlugin* instance = [[FlutterWebBrowserPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"openWebPage" isEqualToString:call.method]) {
        NSString *url = call.arguments[@"url"];
        NSURL *URL = [NSURL URLWithString:url];
        UIViewController *viewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
        if ( viewController.presentedViewController && !viewController.presentedViewController.isBeingDismissed ) {
            viewController = viewController.presentedViewController;
        }
        
        SFSafariViewController *sfvc = [[SFSafariViewController alloc] initWithURL:URL];
        [viewController presentViewController:sfvc animated:YES completion:nil];
        result(nil);
    } else {
        result(FlutterMethodNotImplemented);
    }
}


@end
