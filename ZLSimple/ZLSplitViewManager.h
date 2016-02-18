//
//  ZLSplitViewManager.h
//  Split
//
//  Created by Zi-LO on 2013/11/18.
//  Copyright (c) 2013 Zi-LO All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SubstitutableDetailViewController
@optional
@property (nonatomic, weak) UINavigationItem *detailViewNavigationItem;
@end

@interface ZLSplitViewManager : NSObject <UISplitViewControllerDelegate>
@property (nonatomic, weak) UISplitViewController *splitViewController;
@property (nonatomic, weak) UIViewController *masterViewController;
@property (nonatomic, weak) UIViewController *detailViewController;
@property (nonatomic, strong) UIBarButtonItem *switchMasterViewItem;

+ (ZLSplitViewManager *)shared;

- (void)toggleMasterVisible;

- (void)saveLastViewControllers;
- (UIViewController *)laodLastMasterViewController;
- (UIViewController *)loadLastDetailViewController;


@end
