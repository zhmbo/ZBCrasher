
#import "AppDelegate.h"
#import <ZBCrasher/ZBCrasher.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    /* Easy to use */
    ZBCrasherConfig *config = [[ZBCrasherConfig alloc] initWithAppId:@"P2KV6oTocgdFJFdeVWNHhWxT-MdYXbMMI" appKey:@"4ivNxvzl0e1YGIaEya7LjDo9" serverURLString:@""];
    ZBCrasherManager *manager = [[ZBCrasherManager alloc] initWithConfiguration:config];
    [manager setCrasherCallBack:^(ZBCrasherModel * _Nonnull crashModel) {
        NSLog(@"App crashed. %@", crashModel.reason);
    }];
    [manager setLastCrasherCallBack:^(ZBCrasherModel * _Nonnull crashModel) {
        NSLog(@"App exited due to crash last time. %@", crashModel.reason);
    }];
    
    [manager enableCrasher];
    
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options  API_AVAILABLE(ios(13.0)){
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    if (@available(iOS 13.0, *)) {
        return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
    } else {
        // Fallback on earlier versions
        return nil;
    }
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions  API_AVAILABLE(ios(13.0)){
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
