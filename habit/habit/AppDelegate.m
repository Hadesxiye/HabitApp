//
//  AppDelegate.m
//  habit
//
//  Created by 王浩祯 on 2017/12/26.
//  Copyright © 2017年 王浩祯. All rights reserved.
//

#import "AppDelegate.h"
#import "HabitVC.h"
#import "DailyVC.h"
#import "NeedToDoVC.h"
#import "ChallengeVC.h"
#import "SettingVC.h"

#import "BaseTabBarViewController.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:[[ChallengeVC alloc]init]];
    
   
    
    NSArray *images = @[@"tabbar_home",
                        @"tabbar_message_center",
                        @"tabbar_discover",
                        @"tabbar_home",
                        @"tabbar_profile"];
    NSArray *selectedImages = @[@"tabbar_home_selected",
                                @"tabbar_message_center_selected",
                                @"tabbar_discover_selected",
                                @"tabbar_home_selected",
                                @"tabbar_profile_selected"];
    
    
    HabitVC* habitVC = [[HabitVC alloc]init];
    DailyVC* dailyVC = [[DailyVC alloc]init];
    NeedToDoVC* needVC = [[NeedToDoVC alloc]init];
    ChallengeVC* challengeVC = [[ChallengeVC alloc]init];
    SettingVC* settingVC = [[SettingVC alloc]init];
    
    //创建导航控制器
//    UINavigationController* nav1 = [[UINavigationController alloc]initWithRootViewController:habitVC];
//    UINavigationController* nav2 = [[UINavigationController alloc]initWithRootViewController:dailyVC];
//    UINavigationController* nav3 = [[UINavigationController alloc]initWithRootViewController:needVC];
//    UINavigationController* nav4 = [[UINavigationController alloc]initWithRootViewController:challengeVC];
//    UINavigationController* nav5 = [[UINavigationController alloc]initWithRootViewController:settingVC];
    
    //背景色
    habitVC.view.backgroundColor = myBackgroundColorWhite;
    dailyVC.view.backgroundColor = myBackgroundColorWhite;
    needVC.view.backgroundColor = myBackgroundColorWhite;
    challengeVC.view.backgroundColor = myBackgroundColorWhite;
    settingVC.view.backgroundColor = myBackgroundColorWhite;
    //title
    habitVC.title = @"习惯";
    dailyVC.title = @"每日任务";
    needVC.title = @"待办事项";
    challengeVC.title = @"挑战";
    settingVC.title = @"设置";
    //tabBar

    NSArray *vcs = @[habitVC,dailyVC,needVC,challengeVC,settingVC];

//        NSArray* arr = [NSArray arrayWithObjects:nav1,nav2,nav3,nav4,nav5, nil];

    BaseTabBarViewController *tabBarVC = [BaseTabBarViewController addChildVc:vcs titles:@[@"习惯",@"每日",@"规划",@"挑战",@"设置"] images:images selectedImages:selectedImages tabBarNaviChildVC:[[UINavigationController alloc]init]];
    
    

    self.window.rootViewController = tabBarVC;
  
    [self.window makeKeyAndVisible];
  
    //注册通知
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            NSLog(@"request authorization successed!");
        }
    }];
    //之前注册推送服务，用户点击了同意还是不同意，以及用户之后又做了怎样的更改我们都无从得知，现在 apple 开放了这个 API，我们可以直接获取到用户的设定信息了。
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        NSLog(@"%@",settings);
    }];
    
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
