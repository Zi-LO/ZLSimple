//
//  ZLSimpleSectionItem.h
//  ZLCommon
//
//  Created by Zi-LO on 2013/11/29.
//  Copyright (c) 2013 Zi-LO All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLSimpleCellItem.h"

#pragma mark - ZLSimpleSectionItem

@interface ZLSimpleSectionItem : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSMutableArray *cellItems;

// 指定されたタグのセル情報を返す。
- (ZLSimpleCellItem *)cellItemWithTag:(NSInteger)tag;

// セクション情報にセル情報を追加する
- (ZLSimpleCellItem *)addCellItem:(ZLSimpleCellItem *)cellItem;

// セクション情報にセル情報を追加する
- (ZLSimpleCellItem *)addEmptyCellItem;

// セクション情報にセル情報を追加する
- (ZLSimpleCellItem *)addCellItemWithTitle:(NSString *)title
                                    detail:(NSString *)detail
                                    target:(id)target
                                    action:(SEL)action;

// セクション情報にセル情報を追加する
- (ZLSimpleCellItem *)addCellItemWithTitle:(NSString *)title
                                    detail:(NSString *)detail
                                  callback:(ZLSimpleCellCallback)callback;

// セクション情報にセル情報（ラベルタイプ）を追加する
- (ZLSimpleCellItem *)addLabelCellItemWithTitle:(NSString *)title
                                          value:(id)value
                                       callback:(ZLSimpleCellCallback)callback;

// セクション情報にセル情報（チェックタイプ）を追加する
- (ZLSimpleCellItem *)addCheckCellItemWithTitle:(NSString *)title
                                          value:(id)value
                                       callback:(ZLSimpleCellCallback)callback;

// セクション情報にセル情報（ボタンタイプ）を追加する
- (ZLSimpleCellItem *)addButtonCellItemWithTitle:(NSString *)title
                                           value:(id)value
                                        callback:(ZLSimpleCellCallback)callback;

// セクション情報にセル情報（スイッチタイプ）を追加する
- (ZLSimpleCellItem *)addSwitchCellItemWithTitle:(NSString *)title
                                           value:(id)value
                                        callback:(ZLSimpleCellCallback)callback;

// セクション情報にセル情報（任意のコントロール）を追加する
- (ZLSimpleCellItem *)addControlCellItemWithTitle:(NSString *)title
                                          control:(UIControl *)control
                                         callback:(ZLSimpleCellCallback)callback;

// セクション情報にセル情報を追加する
- (ZLSimpleCellItem *)addCellItemWithTitle:(NSString *)title
                                      type:(ZLSimpleCellType)type
                                     value:(id)value
                                  callback:(ZLSimpleCellCallback)callback;

// セクション情報にセル情報を追加する
- (ZLSimpleCellItem *)addCellItemWithTitle:(NSString *)title
                                    detail:(NSString *)detail
                                      type:(ZLSimpleCellType)type
                                     value:(id)value
                                   content:(id)content
                                       tag:(NSInteger)tag
                                       key:(NSString *)key
                                    target:(id)target
                                    action:(SEL)action;

// セクション情報にセル情報を追加する
- (ZLSimpleCellItem *)addCellItemWithTitle:(NSString *)title
                                    detail:(NSString *)detail
                                      type:(ZLSimpleCellType)type
                                     value:(id)value
                                   content:(id)content
                                       tag:(NSInteger)tag
                                       key:(NSString *)key
                                  callback:(ZLSimpleCellCallback)callback;

@end
