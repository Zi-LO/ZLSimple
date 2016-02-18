//
//  ZLSimpleActionSheet.h
//  ZLSimple
//
//  Created by Zi-LO on 2013/11/29.
//  Copyright (c) 2013 Zi-LO All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLSimpleActionSheet : UIActionSheet

@property (nonatomic, readonly) NSArray *buttonTitles;
@property (nonatomic, strong) void (^clicked)(NSInteger);
@property (nonatomic) BOOL shouldAddCancelButton;

/**
 * タイトル、ボタンタイトルの配列、ボタンタップ時のブロックを指定して初期化する。
 *
 * @param title タイトル
 * @param buttonTitles ボタンタイトルの配列
 * @param clicked ボタンタップ時に処理されるブロック
 * @return 初期化されたインスタンス
 */
- (instancetype)initWithTitle:(NSString *)title
                 buttonTitles:(NSArray *)buttonTitles
                      clicked:(void (^)(NSInteger buttonIndex))clicked;

/**
 * ボタンタイトルの配列を追加する
 *
 * @param buttonTitles 追加するボタンタイトルの配列
 */
- (void)addButtonTitles:(NSArray *)buttonTitles;

@end
