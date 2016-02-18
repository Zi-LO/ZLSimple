//
//  ZLSplitViewManager.m
//  Split
//
//  Created by Zi-LO on 2013/11/18.
//  Copyright (c) 2013 Zi-LO All rights reserved.
//

#import "ZLSplitViewManager.h"

NSString * const kLastMasterViewControllerNameKey = @"ZLSplitLastMasterViewControllerName";
NSString * const kLastMasterViewControllerStackKey = @"ZLSplitLastMasterViewControllerStack";
NSString * const kLastDetailViewControllerNameKey = @"ZLSplitLastDetailViewControllerName";
NSString * const kLastDetailViewControllerStackKey = @"ZLSplitLastDetailViewControllerStack";

@implementation ZLSplitViewManager
{
    SEL _toggleMasterVisible;
}

+ (ZLSplitViewManager *)shared {
    static ZLSplitViewManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)setSplitViewController:(UISplitViewController *)splitViewController
{
    _splitViewController = splitViewController;
    if (_splitViewController.viewControllers.count == 0) {
        [self setMasterViewController:nil detailViewController:nil];
    } else {
        [self setMasterViewController:_splitViewController.viewControllers[0]
                 detailViewController:_splitViewController.viewControllers[1]];
    }
    _splitViewController.delegate = self;
}


#pragma mark - UISplitViewControllerDelegate

// Called when a button should be added to a toolbar for a hidden view controller.
// Implementing this method allows the hidden view controller to be presented via a swipe gesture if 'presentsWithGesture' is 'YES' (the default).
- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
    _switchMasterViewItem = barButtonItem;
    [self switchToggleButtonForVisible:YES];
}

// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    [self switchToggleButtonForVisible:NO];
}

// Called when the view controller is shown in a popover so the delegate can take action like hiding other popovers.
- (void)splitViewController:(UISplitViewController *)svc popoverController:(UIPopoverController *)pc willPresentViewController:(UIViewController *)aViewController
{
    NSLog(@"%s %@", __func__, @"");
}

// Returns YES if a view controller should be hidden by the split view controller in a given orientation.
// (This method is only called on the leftmost view controller and only discriminates portrait from landscape.)
- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return UIInterfaceOrientationIsPortrait(orientation);
}

//- (NSUInteger)splitViewControllerSupportedInterfaceOrientations:(UISplitViewController *)splitViewController
//{}
//
//- (UIInterfaceOrientation)splitViewControllerPreferredInterfaceOrientationForPresentation:(UISplitViewController *)splitViewController
//{}


#pragma mark - other

- (void)setMasterViewController:(UIViewController *)masterViewController
{
    [self setMasterViewController:masterViewController detailViewController:nil];
}

- (void)setDetailViewController:(UIViewController *)detailViewController
{
    [self setMasterViewController:nil detailViewController:detailViewController];
}

- (void)setMasterViewController:(UIViewController *)masterViewController
           detailViewController:(UIViewController *)detailViewController
{
    NSMutableArray *viewControllers = [_splitViewController.viewControllers mutableCopy];
    
    if (!viewControllers) {
        viewControllers = [[NSMutableArray alloc] init];
    }
    
    for (NSInteger count = 1; count <= 2; count++) {
        if (viewControllers.count < count) {
            UIViewController *controller = [[UIViewController alloc] init];
            [viewControllers addObject:controller];
        }
    }
    
    if (masterViewController && ![masterViewController isEqual:viewControllers[0]]) {
        viewControllers[0] = masterViewController;
    }
    _masterViewController = viewControllers[0];
    [self saveLastMasterViewController:_masterViewController];
    
    if (detailViewController && ![detailViewController isEqual:viewControllers[1]]) {
        viewControllers[1] = detailViewController;
    }
    _detailViewController = viewControllers[1];
    [self saveLastDetailViewController:_detailViewController];
    
    _splitViewController.viewControllers = viewControllers;
    
}

- (void)switchToggleButtonForVisible:(BOOL)visible
{
    if (!_switchMasterViewItem) {
        return;
    }
    
    // トグルアクション確保
    _toggleMasterVisible = _switchMasterViewItem.action;
    
    // ボタン整形
    _switchMasterViewItem.title = @"Master";
    
    // 対象のNavigationItemを取得
    NSMutableArray *targetItems = [NSMutableArray array];
    if ([_detailViewController respondsToSelector:@selector(detailViewNavigationItem)]) {
        [targetItems addObject:[_detailViewController performSelector:@selector(detailViewNavigationItem)]];
    } else if ([_detailViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *naviController = (UINavigationController *)_detailViewController;
        [targetItems addObjectsFromArray:[[naviController navigationBar] items]];
    }
    
    // マスタービュー表示ボタンの表示切り替えをおこなう
    if (targetItems.count > 0) {
        UINavigationItem *navigationItem = targetItems[0];
        NSMutableArray *leftBarButtonItems = [navigationItem.leftBarButtonItems mutableCopy];
        UIBarButtonItem *lastToggleButtonItem = nil;
        
        if (!leftBarButtonItems) {
            leftBarButtonItems = [[NSMutableArray alloc] init];
        } else if (leftBarButtonItems.count > 0) {
            UIBarButtonItem *firstLeftButtonItem = leftBarButtonItems[0];
            NSString *actionName = NSStringFromSelector(firstLeftButtonItem.action);
            if ([actionName isEqualToString:@"toggleMasterVisible:"]) {
                lastToggleButtonItem = firstLeftButtonItem;
            }
        }
        
        if (visible) {
            if (!lastToggleButtonItem) {
                [leftBarButtonItems insertObject:_switchMasterViewItem atIndex:0];
            }
        } else {
            if (lastToggleButtonItem) {
                [leftBarButtonItems removeObject:lastToggleButtonItem];
            }
        }
        
        [navigationItem setLeftBarButtonItems:leftBarButtonItems animated:YES];
    }

}

- (void)toggleMasterVisible
{
    if (_splitViewController && _toggleMasterVisible != NULL) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [_splitViewController performSelector:_toggleMasterVisible];
#pragma clang diagnostic pop
    }
}

- (void)saveLastViewControllers
{
    [self saveLastMasterViewController:_masterViewController];
    [self saveLastDetailViewController:_detailViewController];
}

- (void)saveLastMasterViewController:(UIViewController *)controller
{
    // masterViewControler
    NSString *controllerName = NSStringFromClass(controller.class);
    NSMutableArray *controllerNameStack = [NSMutableArray array];
    if ([controller isKindOfClass:[UINavigationController class]]) {
        for (UIViewController *childController in [(UINavigationController*)controller viewControllers]) {
            [controllerNameStack addObject:NSStringFromClass(childController.class)];
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:controllerName
                                              forKey:(NSString *)kLastMasterViewControllerNameKey];
    
    [[NSUserDefaults standardUserDefaults] setObject:controllerNameStack
                                              forKey:(NSString *)kLastMasterViewControllerStackKey];

    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)saveLastDetailViewController:(UIViewController *)controller
{
    // detailViewControler
    NSString *controllerName = NSStringFromClass(controller.class);
    NSMutableArray *controllerNameStack = [NSMutableArray array];
    if ([controller isKindOfClass:[UINavigationController class]]) {
        for (UIViewController *childController in [(UINavigationController*)controller viewControllers]) {
            [controllerNameStack addObject:NSStringFromClass(childController.class)];
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:controllerName
                                              forKey:(NSString *)kLastDetailViewControllerNameKey];
    
    [[NSUserDefaults standardUserDefaults] setObject:controllerNameStack
                                              forKey:(NSString *)kLastDetailViewControllerStackKey];
    
    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (UIViewController *)laodLastMasterViewController
{
    
    // masterViewControler
    NSString *controllerName = [[NSUserDefaults standardUserDefaults] valueForKey:(NSString *)kLastMasterViewControllerNameKey];
    UIViewController *controller = [[NSClassFromString(controllerName) alloc] init];
    if ([controller isKindOfClass:[UINavigationController class]]) {
        NSArray *controllerNameStack = [[NSUserDefaults standardUserDefaults] valueForKey:(NSString *)kLastMasterViewControllerStackKey];
        NSMutableArray *controllerStack = [NSMutableArray array];
        for (NSString *controllerName in controllerNameStack) {
            [controllerStack addObject:[[NSClassFromString(controllerName) alloc] init]];
        }
        [(UINavigationController *)controller setViewControllers:controllerStack animated:NO];
    }
    return controller;
}

- (UIViewController *)loadLastDetailViewController
{
    
    // detailViewControler
    NSString *controllerName = [[NSUserDefaults standardUserDefaults] valueForKey:(NSString *)kLastDetailViewControllerNameKey];
    UIViewController *controller = [[NSClassFromString(controllerName) alloc] init];
    if ([controller isKindOfClass:[UINavigationController class]]) {
        NSArray *controllerNameStack = [[NSUserDefaults standardUserDefaults] valueForKey:(NSString *)kLastDetailViewControllerStackKey];
        NSMutableArray *controllerStack = [NSMutableArray array];
        for (NSString *controllerName in controllerNameStack) {
            [controllerStack addObject:[[NSClassFromString(controllerName) alloc] init]];
        }
        [(UINavigationController *)controller setViewControllers:controllerStack animated:NO];
    }
    return controller;
}

@end
