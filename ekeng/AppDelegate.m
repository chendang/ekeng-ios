//
//  AppDelegate.m
//  Pandora
//
//  Created by Mac Pro_C on 12-12-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "PDRCore.h"
#import "PDRCommonString.h"
#import "WebAppController.h"
#import "OTCBTViewController.h"
#import "QingNiuSDK.h"
@implementation AppDelegate

@synthesize window = _window;

#pragma mark -
#pragma mark app lifecycle
/*
 * @Summary:程序启动时收到push消息
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //设置window属性（在AppDelegate中定义的window属性），初始化windows的大小和位置
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    //设置window的背景
    self.window.backgroundColor = [UIColor whiteColor];
    
    //初始化KCMainViewController
    WebAppController *mainController=[[WebAppController alloc]init];
//    OTCBTViewController *mainController=[[OTCBTViewController alloc]init];
    //设置自定义控制器的大小和window相同，位置为（0，0）
    mainController.view.frame=self.window.bounds;
    //设置此控制器为window的根控制器
    self.window.rootViewController=mainController;
    
    UINavigationController* pNavCon = [[UINavigationController alloc]
                                       initWithRootViewController:_window.rootViewController];
    
    //设置window为应用程序主窗口并设为可见
    [self.window makeKeyAndVisible];
    //UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier ]
    
    UIViewController *topRootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topRootViewController.presentedViewController)
    {
        topRootViewController = topRootViewController.presentedViewController;
    }
    
    //[topRootViewController presentViewController:yourController animated:YES completion:nil];
    //or
//    [topRootViewController myMethod];
    
    [pNavCon release];
    
    //注册轻牛APP
    [QingNiuSDK registerApp:@"123456789" andReleaseModeFlag:NO registerAppBlock:^(QingNiuRegisterAppState qingNiuRegisterAppState) {
        NSLog(@"1registerAppState:%ld",(long)qingNiuRegisterAppState);
    }];
    // 设置当前SDK运行模式
    return [PDRCore initEngineWihtOptions:launchOptions withRunMode:PDRCoreRunModeAppClient];
}

// IOS 9 以下这句会报错，请升级xcode到最新或者删除此代码
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem
  completionHandler:(void(^)(BOOL succeeded))completionHandler{
    [PDRCore handleSysEvent:PDRCoreSysEventPeekQuickAction withObject:shortcutItem];
    completionHandler(true);
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[PDRCore Instance] handleSysEvent:PDRCoreSysEventEnterBackground withObject:nil];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[PDRCore Instance] handleSysEvent:PDRCoreSysEventEnterForeGround withObject:nil];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[PDRCore Instance] unLoad];
}

#pragma mark -
#pragma mark URL

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    [self application:application handleOpenURL:url];
    return YES;
}

/*
 * @Summary:程序被第三方调用，传入参数启动
 *
 */
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    [[PDRCore Instance] handleSysEvent:PDRCoreSysEventOpenURL withObject:url];
    return YES;
}


#pragma mark -
#pragma mark APNS
/*
 * @Summary:远程push注册成功收到DeviceToken回调
 *
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[PDRCore Instance] handleSysEvent:PDRCoreSysEventRevDeviceToken withObject:deviceToken];
}

/*
 * @Summary: 远程push注册失败
 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [[PDRCore Instance] handleSysEvent:PDRCoreSysEventRegRemoteNotificationsError withObject:error];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [[PDRCore Instance] handleSysEvent:PDRCoreSysEventRevRemoteNotification withObject:userInfo];
}

/*
 * @Summary:程序收到本地消息
 */
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [[PDRCore Instance] handleSysEvent:PDRCoreSysEventRevLocalNotification withObject:notification];
}


//- (void)dealloc
//{
//    [super dealloc];
//}

@end
