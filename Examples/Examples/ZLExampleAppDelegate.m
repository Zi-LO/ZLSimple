//
//  ZLExampleAppDelegate.m
//  Examples
//
//  Created by ブックライブ on 2014/06/23.
//  Copyright (c) 2014年 Zi-LO. All rights reserved.
//

#import "ZLExampleAppDelegate.h"
#import "ZLExampleViewController.h"

@implementation ZLExampleAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIViewController *rootViewController = [[ZLExampleViewController alloc] init];
    self.window.rootViewController = rootViewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
