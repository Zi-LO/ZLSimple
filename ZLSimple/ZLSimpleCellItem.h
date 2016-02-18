//
//  ZLSimpleCellItem.h
//  ZLCommon
//
//  Created by Zi-LO on 2013/11/29.
//  Copyright (c) 2013 Zi-LO All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ZLSimpleCellTypeNormal = 0,
    ZLSimpleCellTypeDisclosureIndicator,
    ZLSimpleCellTypeDetailDisclosureButton,
    ZLSimpleCellTypeLabel,
    ZLSimpleCellTypeCheckmark,
    ZLSimpleCellTypeDetailButton,
    ZLSimpleCellTypeButton,
    ZLSimpleCellTypeSwitch,
    ZLSimpleCellTypeAnyControl,
} ZLSimpleCellType;


#pragma mark - ZLSimpleCellItem

@class ZLSimpleCellItem;

typedef void (^ZLSimpleCellCallback)(ZLSimpleCellItem *cellItem, UITableViewCell *cell);

@interface ZLSimpleCellItem : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *detail;
@property (nonatomic, strong) id target;
@property (nonatomic) SEL action;
@property (nonatomic) ZLSimpleCellType type;
@property (nonatomic, strong) id value;
@property (nonatomic, strong) id content;
@property (nonatomic) NSInteger tag;
@property (nonatomic) NSString *key;
@property (nonatomic, copy) ZLSimpleCellCallback callback;
@end
