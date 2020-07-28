#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"

#import <Flutter/Flutter.h>



@implementation AppDelegate
- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
//  FlutterViewController* controller = (FlutterViewController*)self.window.rootViewController;

//  FlutterMethodChannel* batteryChannel = [FlutterMethodChannel
//                                          methodChannelWithName:@"samples.flutter.io/battery"
//                                          binaryMessenger:controller];
//
//
//      [batteryChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
//        if ([@"getBatteryLevel" isEqualToString:call.method])
//        {
//          int batteryLevel = [self getBatteryLevel_a];
//
//          if (batteryLevel == -1) {
//            result([FlutterError errorWithCode:@"UNAVAILABLE"
//                                      message:@"电池信息不可用"
//                                      details:nil]);
//          } else {
//           result(@(batteryLevel));
//          }
//        }
//        else
//        {
//          result(FlutterMethodNotImplemented);
//        }
//      }];

  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

//
//- (int)getBatteryLevel_a {
//  UIDevice* device = UIDevice.currentDevice;
//  device.batteryMonitoringEnabled = YES;
//  if (device.batteryState == UIDeviceBatteryStateUnknown) {
//    return -1;
//  } else {
//    return (int)(device.batteryLevel * 100);
//  }
// }


/*
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}
*/
@end
