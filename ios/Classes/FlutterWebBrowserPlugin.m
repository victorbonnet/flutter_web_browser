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
        NSString *toolbarColorArg = call.arguments[@"toolbar_color"];
        NSString *controlColorArg = call.arguments[@"ios_control_color"];
        NSURL *URL = [NSURL URLWithString:url];
        UIViewController *viewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
        if ( viewController.presentedViewController && !viewController.presentedViewController.isBeingDismissed ) {
            viewController = viewController.presentedViewController;
        }
        
        if (@available(iOS 9.0, *)) {
            SFSafariViewController *sfvc = [[SFSafariViewController alloc] initWithURL:URL];
                    if(toolbarColorArg != (id)[NSNull null]) {
                        if (@available(iOS 10.0, *)) {
                            sfvc.preferredBarTintColor = [FlutterWebBrowserPlugin colorFromHexString:toolbarColorArg];
                        }
                    }  
                    if(controlColorArg != (id)[NSNull null]) {
                        if (@available(iOS 10.0, *)) {
                            sfvc.preferredControlTintColor = [FlutterWebBrowserPlugin colorFromHexString:controlColorArg];
                        } 
                    }   
            [viewController presentViewController:sfvc animated:YES completion:nil];
        } else {
            [[UIApplication sharedApplication] openURL:URL];
        }
        result(nil);
    } else {
        result(FlutterMethodNotImplemented);
    }
}

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}


@end
