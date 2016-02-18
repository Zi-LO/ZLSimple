//
//  ZLSimpleTableViewController.h
//  ZLCommon
//
//  Created by Zi-LO on 2013/11/29.
//  Copyright (c) 2013 Zi-LO All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLSimpleCellItem.h"
#import "ZLSimpleSectionItem.h"

#pragma mark - ZLSimpleTableViewController

@interface ZLSimpleTableViewController : UITableViewController

// セクション情報の配列。
@property (nonatomic, strong)NSMutableArray *sectionItems;

// セクション情報を追加する。
- (ZLSimpleSectionItem *)addSectionItemWithTitle:(NSString *)title;

// データソース（セクション情報）をクリアする。
- (void)clearDataSource;

// セクション情報リストを設定する（オーバーライド用）。
- (void)setupSectionItem;

// セルの外観を設定する（オーバーライド用）。
- (void)setupCommonAppearanceForCell:(UITableViewCell **)aCell;

// 指定されたタグのセル情報を返す。
- (ZLSimpleCellItem *)cellItemWithTag:(NSInteger)tag;

@end
