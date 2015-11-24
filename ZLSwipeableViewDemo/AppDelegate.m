//
//  AppDelegate.m
//  ZLSwipeableViewDemo
//
//  Created by Zhixuan Lai on 11/1/14.
//  Copyright (c) 2014 Zhixuan Lai. All rights reserved.
//

#import "AppDelegate.h"

#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"
#import "settingViewController.h"
#import "myInfoViewController.h"
#import "creatPhotoViewController.h"
#import "mainViewController.h"
#import "extendMothods.h"
@interface AppDelegate (){
    UIViewController * g_viewController;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self setupViewControllers];
//    UINavigationController * t_homeVC = [[UINavigationController alloc] initWithRootViewController:g_viewController];
//    t_homeVC.navigationBar.hidden = YES;
    [self.window setRootViewController:g_viewController];
    [self.window makeKeyAndVisible];
    
    [self firstFinishLaunch];
    // Override point for customization after application launch.
    return YES;
}
-(void)firstFinishLaunch{
// 1.0 清除数据
    WhichKind t_kind = isBOOL;
    setNSUserDefaults(@"IsFirstLoadMainView", t_kind, @"0");

}
- (void)setupViewControllers {
    UIViewController * firstViewController = [[mainViewController alloc] init];
    UIViewController *firstNavigationController = [[UINavigationController alloc]
                                                   initWithRootViewController:firstViewController];
    firstViewController.title = @"动态";
    
    UIViewController *secondViewController = [[creatPhotoViewController alloc] init];
    UIViewController *secondNavigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:secondViewController];
    secondViewController.title = @"创造动态";
    UIViewController *thirdViewController = [[myInfoViewController alloc] init];
    UIViewController *thirdNavigationController = [[UINavigationController alloc]
                                                   initWithRootViewController:thirdViewController];
    thirdViewController.title = @"个人中心";
//    RDVTabBarController *tabBarController = [[RDVTabBarController alloc] init];
//    [tabBarController setViewControllers:@[firstNavigationController, secondNavigationController,
//                                           thirdNavigationController]];
//    g_viewController = tabBarController;
//    
//    [self customizeTabBarForController:tabBarController];
    [self customTabBarForController:@[firstNavigationController, secondNavigationController,thirdNavigationController]];
    
    UITabBarController *tb=[[UITabBarController alloc]init];
    tb.viewControllers = @[firstNavigationController, secondNavigationController,thirdNavigationController];
    g_viewController = tb;
}
- (void)customTabBarForController:(NSArray *)tabBarControllers {
  
    
    NSArray *tabBarItemImages = @[@"first", @"second", @"third"];
    NSArray * titleArr = @[@"动态",@"创造动态",@"个人中心"];
    NSInteger index = 0;
    for (UIViewController *item in tabBarControllers) {
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",
                                                      [tabBarItemImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",
                                                        [tabBarItemImages objectAtIndex:index]]];
      
        item.tabBarItem = [[UITabBarItem alloc]initWithTitle:titleArr[index] image:unselectedimage selectedImage:selectedimage];
          item.hidesBottomBarWhenPushed=YES;
        index++;
    }
}

- (void)customizeTabBarForController:(RDVTabBarController *)tabBarController {
    UIImage *finishedImage = [UIImage imageNamed:@"tabbar_selected_background"];
    UIImage *unfinishedImage = [UIImage imageNamed:@"tabbar_normal_background"];
    NSArray *tabBarItemImages = @[@"first", @"second", @"third"];
    
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
        [item setBackgroundSelectedImage:finishedImage withUnselectedImage:unfinishedImage];
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",
                                                      [tabBarItemImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",
                                                        [tabBarItemImages objectAtIndex:index]]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        
        index++;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state.
    // This can occur for certain types of temporary interruptions (such as an
    // incoming phone call or SMS message) or when the user quits the
    // application
    // and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down
    // OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate
    // timers, and store enough application state information to restore your
    // application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called
    // instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive
    // state;
    // here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the
    // application was inactive. If the application was previously in the
    // background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if
    // appropriate. See also applicationDidEnterBackground:.
}

@end
