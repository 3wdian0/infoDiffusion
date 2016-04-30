//
//  AppDelegate.m
//  Notice
//
//  Created by w3dian0 on 4/5/16.
//  Copyright © 2016 fzuacm. All rights reserved.
//

#import "AppDelegate.h"

#import "WLoginViewController.h"

#import "WHomeViewController.h"
#import "WHobbyViewController.h"
#import "WNoticeViewController.h"
#import "WPersonalViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
     WLoginViewController *loginVC = [[WLoginViewController alloc]init];
     // self.window.rootViewController =loginVC;
    
    
    
    WHomeViewController *homeVC = [[WHomeViewController alloc]init];
    UINavigationController *navHome = [[UINavigationController alloc]initWithRootViewController:homeVC];
   [self chushihua:navHome.navigationBar];
   
    
    WHobbyViewController *hobbyVC = [[WHobbyViewController alloc]init];
    UINavigationController *navHobby = [[UINavigationController alloc]initWithRootViewController:hobbyVC];
    
    
    WNoticeViewController *noticeVC = [[WNoticeViewController alloc]init];
    UINavigationController *navNotice = [[UINavigationController alloc]initWithRootViewController:noticeVC];
    [self chushihua:navNotice.navigationBar];
    
    /*
    navNotice.navigationBar.barTintColor = [UIColor colorWithRed:60.0/255.0 green:210.0/255.0 blue:255.0/255.0 alpha:1];
    navNotice.navigationBar.tintColor = [UIColor whiteColor];
    navNotice.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
     */
   
    
    
    WPersonalViewController *personalVC = [[WPersonalViewController alloc]init];
    UINavigationController *navPersonal = [[UINavigationController alloc]initWithRootViewController:personalVC];
     [self chushihua:navPersonal.navigationBar];
    
    
    UITabBarController *tabBarController = [[UITabBarController alloc]init];
    tabBarController.viewControllers = @[navPersonal,navNotice, navHome];
    self.window.rootViewController =tabBarController;
    
    return YES;
}

-(void)chushihua:(UINavigationBar*)navBar{
    navBar.barTintColor = [UIColor colorWithRed:60.0/255.0 green:210.0/255.0 blue:255.0/255.0 alpha:1];
    navBar.tintColor = [UIColor whiteColor];
    navBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    

}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}




// 本地通知回调函数，当应用程序在前台时调用
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSLog(@"应用程序在前台noti:%@",notification);
    
    // 这里真实需要处理交互的地方
    // 获取通知所带的数据
    NSString *notMess = [notification.userInfo objectForKey:@"key"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"本地通知(前台)"
                                                    message:notMess
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    // 更新显示的徽章个数
    NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    badge--;
    badge = badge >= 0 ? badge : 0;
    [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
    
    // 在不需要再推送时，可以取消推送
    [WNoticeViewController cancelLocalNotificationWithKey:@"key"];
}

@end
