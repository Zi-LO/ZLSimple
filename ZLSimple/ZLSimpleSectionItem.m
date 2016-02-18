//
//  ZLSimpleSectionItem.m
//  ZLCommon
//
//  Created by Zi-LO on 2013/11/29.
//  Copyright (c) 2013 Zi-LO All rights reserved.
//

#import "ZLSimpleSectionItem.h"

#pragma mark - ZLSimpleSectionItem

@implementation ZLSimpleSectionItem
- (id)init
{
    self = [super init];
    if (self) {
        _cellItems = [[NSMutableArray alloc] init];
    }
    return self;
}

// 指定されたタグのセル情報を返す。
- (ZLSimpleCellItem *)cellItemWithTag:(NSInteger)tag
{
    ZLSimpleCellItem *targetCellItem = nil;
    
    for (ZLSimpleCellItem *cellItem in _cellItems) {
        if (cellItem.tag == tag) {
            targetCellItem = cellItem;
        }
    }
    
    return targetCellItem;
}

- (ZLSimpleCellItem *)addCellItem:(ZLSimpleCellItem *)cellItem
{
    if (cellItem) {
        [self.cellItems addObject:cellItem];
    }
    
    return cellItem;
}

- (ZLSimpleCellItem *)addEmptyCellItem
{
    ZLSimpleCellItem *cellItem = [[ZLSimpleCellItem alloc] init];
    [self addCellItem:cellItem];
    
    return cellItem;
}

- (ZLSimpleCellItem *)addCellItemWithTitle:(NSString *)title
                                    detail:(NSString *)detail
                                    target:(id)target
                                    action:(SEL)action
{
    return [self addCellItemWithTitle:title
                               detail:detail
                                 type:ZLSimpleCellTypeNormal
                                value:nil
                              content:nil
                                  tag:0
                                  key:nil
                               target:target
                               action:action
                             callback:nil];
}

- (ZLSimpleCellItem *)addCellItemWithTitle:(NSString *)title
                                    detail:(NSString *)detail
                                  callback:(ZLSimpleCellCallback)callback
{
    return [self addCellItemWithTitle:title
                               detail:detail
                                 type:ZLSimpleCellTypeNormal
                                value:nil
                              content:nil
                                  tag:0
                                  key:nil
                               target:nil
                               action:NULL
                             callback:callback];
}


- (ZLSimpleCellItem *)addCellItemWithTitle:(NSString *)title
                                      type:(ZLSimpleCellType)type
                                     value:(id)value
                                  callback:(ZLSimpleCellCallback)callback
{
    return [self addCellItemWithTitle:title
                               detail:nil
                                 type:type
                                value:value
                              content:nil
                                  tag:0
                                  key:nil
                               target:nil
                               action:NULL
                             callback:callback];
}


// セクション情報にセル情報（ラベルタイプ）を追加する
- (ZLSimpleCellItem *)addLabelCellItemWithTitle:(NSString *)title
                                          value:(id)value
                                       callback:(ZLSimpleCellCallback)callback
{
    return [self addCellItemWithTitle:title
                               detail:nil
                                 type:ZLSimpleCellTypeLabel
                                value:value
                              content:nil
                                  tag:0
                                  key:nil
                               target:nil
                               action:NULL
                             callback:callback];
}

// セクション情報にセル情報（チェックタイプ）を追加する
- (ZLSimpleCellItem *)addCheckCellItemWithTitle:(NSString *)title
                                          value:(id)value
                                       callback:(ZLSimpleCellCallback)callback
{
    return [self addCellItemWithTitle:title
                               detail:nil
                                 type:ZLSimpleCellTypeCheckmark
                                value:value
                              content:nil
                                  tag:0
                                  key:nil
                               target:nil
                               action:NULL
                             callback:callback];
}

// セクション情報にセル情報（ボタンタイプ）を追加する
- (ZLSimpleCellItem *)addButtonCellItemWithTitle:(NSString *)title
                                           value:(id)value
                                        callback:(ZLSimpleCellCallback)callback
{
    return [self addCellItemWithTitle:title
                               detail:nil
                                 type:ZLSimpleCellTypeButton
                                value:value
                              content:nil
                                  tag:0
                                  key:nil
                               target:nil
                               action:NULL
                             callback:callback];
}


// セクション情報にセル情報（スイッチタイプ）を追加する
- (ZLSimpleCellItem *)addSwitchCellItemWithTitle:(NSString *)title
                                           value:(id)value
                                        callback:(ZLSimpleCellCallback)callback
{
    return [self addCellItemWithTitle:title
                               detail:nil
                                 type:ZLSimpleCellTypeSwitch
                                value:value
                              content:nil
                                  tag:0
                                  key:nil
                               target:nil
                               action:NULL
                             callback:callback];
}


// セクション情報にセル情報（任意のコントロール）を追加する
- (ZLSimpleCellItem *)addControlCellItemWithTitle:(NSString *)title
                                          control:(UIControl *)control
                                         callback:(ZLSimpleCellCallback)callback
{
    return [self addCellItemWithTitle:title
                               detail:nil
                                 type:ZLSimpleCellTypeAnyControl
                                value:nil
                              content:control
                                  tag:0
                                  key:nil
                               target:nil
                               action:NULL
                             callback:callback];
}


- (ZLSimpleCellItem *)addCellItemWithTitle:(NSString *)title
                                    detail:(NSString *)detail
                                      type:(ZLSimpleCellType)type
                                     value:(id)value
                                   content:(id)content
                                       tag:(NSInteger)tag
                                       key:(NSString *)key
                                    target:(id)target
                                    action:(SEL)action
{
    return [self addCellItemWithTitle:title
                               detail:detail
                                 type:type
                                value:value
                              content:content
                                  tag:tag
                                  key:key
                               target:target
                               action:action
                             callback:nil];
}

- (ZLSimpleCellItem *)addCellItemWithTitle:(NSString *)title
                                    detail:(NSString *)detail
                                      type:(ZLSimpleCellType)type
                                     value:(id)value
                                   content:(id)content
                                       tag:(NSInteger)tag
                                       key:(NSString *)key
                                  callback:(ZLSimpleCellCallback)callback;
{
    return [self addCellItemWithTitle:title
                               detail:detail
                                 type:type
                                value:value
                              content:content
                                  tag:tag
                                  key:key
                               target:nil
                               action:NULL
                             callback:callback];
}

- (ZLSimpleCellItem *)addCellItemWithTitle:(NSString *)title
                                    detail:(NSString *)detail
                                      type:(ZLSimpleCellType)type
                                     value:(id)value
                                   content:(id)content
                                       tag:(NSInteger)tag
                                       key:(NSString *)key
                                    target:(id)target
                                    action:(SEL)action
                                  callback:(ZLSimpleCellCallback)callback;
{
    
    ZLSimpleCellItem *cellItem = [[ZLSimpleCellItem alloc] init];
    cellItem.title = title;
    cellItem.detail = detail;
    cellItem.type = type;
    cellItem.value = value;
    cellItem.content = content;
    cellItem.tag = tag;
    cellItem.key = key;
    cellItem.target = target;
    cellItem.action = action;
    cellItem.callback = callback;
    
    [self addCellItem:cellItem];
    
    return cellItem;
}
@end
