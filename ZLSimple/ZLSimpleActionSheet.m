//
//  ZLSimpleActionSheet.m
//  ZLSimple
//
//  Created by Zi-LO on 2013/11/29.
//  Copyright (c) 2013 Zi-LO All rights reserved.
//

#import "ZLSimpleActionSheet.h"

@interface ZLSimpleActionSheet () <UIActionSheetDelegate>
{
    NSMutableArray *_buttonTitles;
}
@end

@implementation ZLSimpleActionSheet


#pragma mark - life cycle

// 初期化
- (instancetype)init
{
    self = [super init];
    if (self) {
        _shouldAddCancelButton = YES;
        self.delegate = self;
    }
    return self;
}

// タイトル、ボタンタイトルの配列、ボタンタップ時のブロックを指定して初期化する。
- (instancetype)initWithTitle:(NSString *)title
                 buttonTitles:(NSArray *)buttonTitles
                      clicked:(void (^)(NSInteger buttonIndex))clicked
{
    self = [super init];
    if (self) {
        self.delegate = self;
        self.title = title;
        [self addButtonTitles:buttonTitles];
        self.clicked = clicked;
    }
    return self;
}


#pragma mark - property

- (NSArray *)buttonTitles
{
    return _buttonTitles;
}


#pragma mark - public method

- (void)addButtonTitles:(NSArray *)buttonTitles;
{
    
    for (NSString *title in buttonTitles) {
        [self addButtonWithTitle:title];
    }
    
    if (!_buttonTitles) {
        _buttonTitles = [[NSMutableArray alloc] init];
    }
    
    [_buttonTitles addObjectsFromArray:buttonTitles];
    
}


#pragma mark - UIActionSheetDelegate

// 表示直前
- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    // 必要ならキャンセルボタン追加
    if (self.shouldAddCancelButton) {
        [self addButtonWithTitle:@"キャンセル"];
        self.cancelButtonIndex = self.buttonTitles.count;
    }
}

// ボタンタップ時
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // キャンセルボタン選択
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    
    // ブロック実行
    if (_clicked) {
        _clicked(buttonIndex);
    }
    
}

@end
