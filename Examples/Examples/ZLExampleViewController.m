//
//  ZLExampleViewController.m
//  Examples
//
//  Created by ブックライブ on 2014/06/23.
//  Copyright (c) 2014年 Zi-LO. All rights reserved.
//

#import <ZLSimple/ZLSimple.h>

#import "ZLExampleViewController.h"

@interface ZLExampleViewController ()

@end

@implementation ZLExampleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGRect lastControllFrame = CGRectMake(0, 20, CGRectGetWidth(self.view.bounds), 2);
    
    UIButton * (^newButton)(CGRect*, NSString*, SEL) = ^(CGRect *lastFrame, NSString *title, SEL action){
        lastFrame->origin.y += lastFrame->size.height;
        lastFrame->size.height = 40;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = *lastFrame;
        [btn setTitle:title forState:UIControlStateNormal];
        [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
        [btn sizeToFit];
        return btn;
    };
    
    [self.view addSubview:newButton(&lastControllFrame, @"openTable", @selector(openTable))];
    
    
}

- (void)openModalView:(UIViewController *)controller
{
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithTitle:@"Close"
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self action:@selector(closeModalView)];
    controller.navigationItem.leftBarButtonItem = closeItem;
    
    UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:naviController animated:YES completion:nil];
    
}

- (void)closeModalView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message
{
    [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (void)openTable
{
    ZLSimpleTableViewController *controller = [[ZLSimpleTableViewController alloc] init];
    
    ZLSimpleSectionItem *sectionItem = [controller addSectionItemWithTitle:nil];
    
    [sectionItem addCellItemWithTitle:@"Normal"
                                 type:ZLSimpleCellTypeNormal
                                value:nil
                             callback:^(ZLSimpleCellItem *cellItem, UITableViewCell *cell)
     {
         [self showAlertWithTitle:cellItem.title message:[cellItem.value description]];
     }];
    
    [sectionItem addCellItemWithTitle:@"DisclosureIndicator"
                                 type:ZLSimpleCellTypeDisclosureIndicator
                                value:nil
                             callback:^(ZLSimpleCellItem *cellItem, UITableViewCell *cell)
     {
         [self showAlertWithTitle:cellItem.title message:[cellItem.value description]];
     }];
    
    [sectionItem addCellItemWithTitle:@"DetailDisclosureButton"
                                 type:ZLSimpleCellTypeDetailDisclosureButton
                                value:nil
                             callback:^(ZLSimpleCellItem *cellItem, UITableViewCell *cell)
     {
         [self showAlertWithTitle:cellItem.title message:[cellItem.value description]];
     }];
    
    [sectionItem addCellItemWithTitle:@"Label"
                                 type:ZLSimpleCellTypeLabel
                                value:@"ラベル"
                             callback:^(ZLSimpleCellItem *cellItem, UITableViewCell *cell)
     {
         [self showAlertWithTitle:cellItem.title message:[cellItem.value description]];
     }];
    
    [sectionItem addCellItemWithTitle:@"Checkmark"
                                 type:ZLSimpleCellTypeCheckmark
                                value:nil
                             callback:^(ZLSimpleCellItem *cellItem, UITableViewCell *cell)
     {
         [self showAlertWithTitle:cellItem.title message:[cellItem.value description]];
     }];
    
    [sectionItem addCellItemWithTitle:@"DetailButton"
                                 type:ZLSimpleCellTypeDetailButton
                                value:nil
                             callback:^(ZLSimpleCellItem *cellItem, UITableViewCell *cell)
     {
         [self showAlertWithTitle:cellItem.title message:[cellItem.value description]];
     }];
    
    [sectionItem addCellItemWithTitle:@"Button"
                                 type:ZLSimpleCellTypeButton
                                value:@"ボタン"
                             callback:^(ZLSimpleCellItem *cellItem, UITableViewCell *cell)
     {
         [self showAlertWithTitle:cellItem.title message:[cellItem.value description]];
     }];
    
    [sectionItem addCellItemWithTitle:@"Switch"
                                 type:ZLSimpleCellTypeSwitch
                                value:nil
                             callback:^(ZLSimpleCellItem *cellItem, UITableViewCell *cell)
     {
         [self showAlertWithTitle:cellItem.title message:[cellItem.value description]];
     }];
    
    
    UISlider *slider = [[UISlider alloc] init];
    slider.maximumValue = 100;
    slider.value = 50.5f;
    slider.continuous = NO;
    
    [sectionItem addControlCellItemWithTitle:@"AnyControl"
                                     control:slider
                                    callback:^(ZLSimpleCellItem *cellItem, UITableViewCell *cell)
     {
         NSString *valueString = [NSString stringWithFormat:@"%f", slider.value];
         [self showAlertWithTitle:cellItem.title message:valueString];
     }];
    
    NSArray *segmentedItems = @[@"first", @"second", @"third"];
    UISegmentedControl *segmented = [[UISegmentedControl alloc] initWithItems:segmentedItems];
    segmented.selectedSegmentIndex = 1;
    
    [sectionItem addControlCellItemWithTitle:@"AnyControl"
                                     control:segmented
                                    callback:^(ZLSimpleCellItem *cellItem, UITableViewCell *cell)
     {
         NSString *valueString = [NSString stringWithFormat:@"%ld", (long)segmented.selectedSegmentIndex];
         [self showAlertWithTitle:cellItem.title message:valueString];
     }];
    
    [self openModalView:controller];
}

@end
