#import "FlutterWebBrowserPlugin.h"
#import <SafariServices/SafariServices.h>

// Thank you https://stackoverflow.com/a/7180905/375209
@interface UIColor(HexString)
+ (UIColor *) colorWithHexString: (NSString *) hexString;
+ (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length;
@end

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
        if (viewController.presentedViewController && !viewController.presentedViewController.isBeingDismissed ) {
            viewController = viewController.presentedViewController;
        }
        
        if (@available(iOS 9.0, *)) {
            // SafariViewController only supports http & https, calling it with anything else will cause a App crash.
            bool supported = [URL.scheme isEqualToString:@"http"] || [URL.scheme isEqualToString:@"https"];
            if (supported) {
                NSDictionary *options = call.arguments[@"ios_options"];
                
                SFSafariViewController *sfvc;
                if (@available(iOS 11.0, *)) {
                    SFSafariViewControllerConfiguration *config = [[SFSafariViewControllerConfiguration alloc] init];
                    config.barCollapsingEnabled = options[@"barCollapsingEnabled"];
                    config.entersReaderIfAvailable = options[@"entersReaderIfAvailable"];
                    
                    sfvc = [[SFSafariViewController alloc] initWithURL:URL configuration:config];
                    
                    if (options[@"dismissButtonStyle"] != [NSNull null]) {
                        sfvc.dismissButtonStyle = [options[@"dismissButtonStyle"] intValue];
                    }
                } else {
                    sfvc = [[SFSafariViewController alloc] initWithURL:URL];
                }
                
                if (@available(iOS 10.0, *)) {
                    if (options[@"preferredBarTintColor"] != [NSNull null]) {
                        sfvc.preferredBarTintColor = [UIColor colorWithHexString:options[@"preferredBarTintColor"]];
                    }
                    if (options[@"preferredControlTintColor"] != [NSNull null]) {
                        sfvc.preferredControlTintColor = [UIColor colorWithHexString:options[@"preferredControlTintColor"]];
                    }
                }
                
                sfvc.modalPresentationCapturesStatusBarAppearance = options[@"modalPresentationCapturesStatusBarAppearance"];

                [viewController presentViewController:sfvc animated:YES completion:nil];
            } else {
                [[UIApplication sharedApplication] openURL:URL];
            }
        } else {
            [[UIApplication sharedApplication] openURL:URL];
        }
        result(nil);
    } else if ([@"warmup" isEqualToString:call.method]) {
        result(YES);
    } else {
        result(FlutterMethodNotImplemented);
    }
}

@end



@implementation UIColor(HexString)

+ (UIColor *) colorWithHexString: (NSString *) hexString {
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 1];
            green = [self colorComponentFrom: colorString start: 1 length: 1];
            blue  = [self colorComponentFrom: colorString start: 2 length: 1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom: colorString start: 0 length: 1];
            red   = [self colorComponentFrom: colorString start: 1 length: 1];
            green = [self colorComponentFrom: colorString start: 2 length: 1];
            blue  = [self colorComponentFrom: colorString start: 3 length: 1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 2];
            green = [self colorComponentFrom: colorString start: 2 length: 2];
            blue  = [self colorComponentFrom: colorString start: 4 length: 2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom: colorString start: 0 length: 2];
            red   = [self colorComponentFrom: colorString start: 2 length: 2];
            green = [self colorComponentFrom: colorString start: 4 length: 2];
            blue  = [self colorComponentFrom: colorString start: 6 length: 2];
            break;
        default:
            [NSException raise:@"Invalid color value" format: @"Color value %@ is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString];
            break;
    }
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

+ (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length {
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

@end
