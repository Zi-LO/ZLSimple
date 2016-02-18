//
//  ZLSimpleTableViewController.m
//  ZLCommon
//
//  Created by Zi-LO on 2013/11/29.
//  Copyright (c) 2013 Zi-LO All rights reserved.
//

#import "ZLSimpleTableViewController.h"

static NSString *const kZLSimpleCellIdentifierSubtitle = @"ZLSimpleCellIdentifierSubtitle";
static NSString *const kZLSimpleCellIdentifierValue1 = @"ZLSimpleCellIdentifierValue1";
static NSString *const kZLSimpleCellIdentifierValue2 = @"ZLSimpleCellIdentifierValue2";
static NSString *const kZLSimpleCellIdentifierButton = @"ZLSimpleCellIdentifierButton";
static NSString *const kZLSimpleCellIdentifierSwitch = @"ZLSimpleCellIdentifierSwitch";

static const UIEdgeInsets kControlMargin = {8, 8, 8, 8};
static const CGFloat kValueLabelWidth = 36;
static const CGFloat kValueLabelFontSize = 14;
static const CGFloat kAnyControlWidthRatio = 0.6f;


#pragma mark - UILabel (ZLSimpleTableView)

@interface UILabel (ZLSimpleTableView)
@end
@implementation UILabel (ZLSimpleTableView)

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"value"]) {
        [self setTextForReadableValue:[change[@"new"] doubleValue]];
    }
}

- (void)setTextForReadableValue:(CGFloat)value
{
    NSString *valueString = nil;
    
    if (value <= 1.0f) {
        valueString = [NSString stringWithFormat:@"%0.2f", value];
        
    } else if (value <= 10.0f) {
        valueString = [NSString stringWithFormat:@"%0.1f", value];
        
    } else {
        valueString = [NSString stringWithFormat:@"%0.0f", value];
    }
    
    self.text = valueString;
}
@end


#pragma mark - ZLSimpleTableViewController

@implementation ZLSimpleTableViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _sectionItems = [[NSMutableArray alloc] init];
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupSectionItem];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sectionItems.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    ZLSimpleSectionItem *sectionItem = _sectionItems[section];
    return sectionItem.title;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ZLSimpleSectionItem *sectionItem = _sectionItems[section];
    return sectionItem.cellItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZLSimpleCellItem *cellItem = [self cellItemAtIndexPath:indexPath];

    ZLSimpleCellType type = cellItem.type;
    switch (type) {
        case ZLSimpleCellTypeNormal:
            return [self cellForNormalWithInfo:cellItem];
            break;
            
        case ZLSimpleCellTypeDisclosureIndicator:
            return [self cellForDisclosureIndicatorWithInfo:cellItem];
            break;
            
        case ZLSimpleCellTypeDetailDisclosureButton:
            return [self cellForDetailDisclosureButtonWithInfo:cellItem];
            break;
            
        case ZLSimpleCellTypeCheckmark:
            return [self cellForCheckmarkWithInfo:cellItem];
            break;
            
        case ZLSimpleCellTypeDetailButton:
            return [self cellForDetailButtonWithInfo:cellItem];
            break;
            
        case ZLSimpleCellTypeLabel:
            return [self cellForLabelWithInfo:cellItem];
            break;
            
        case ZLSimpleCellTypeButton:
            return [self cellForButtonWithInfo:cellItem];
            break;
            
        case ZLSimpleCellTypeSwitch:
            return [self cellForSwitchWithInfo:cellItem];
            break;
            
        case ZLSimpleCellTypeAnyControl:
            return [self cellForAnyControlWithInfo:cellItem];
            break;
            
        default:
            return [self cellForNormalWithInfo:cellItem];
            break;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    // observer開放
    for (UIView *view in cell.contentView.subviews) {
        if ([view isKindOfClass:[UISlider class]] && [cell.accessoryView isKindOfClass:[UILabel class]]) {
            [view removeObserver:cell.accessoryView forKeyPath:@"value"];
        }
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    ZLSimpleCellItem *cellItem = [self cellItemAtIndexPath:indexPath];
    
    // チェック型の場合、値を更新
    ZLSimpleCellType cellType = cellItem.type;
    
    if (cellType == ZLSimpleCellTypeButton || cellType == ZLSimpleCellTypeSwitch) {
        return;
    }
    
    if (cellType == ZLSimpleCellTypeCheckmark) {
        BOOL isChecked = ![cellItem.value boolValue];
        cellItem.value = @(isChecked);
        if (isChecked) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }

    // 選択解除
    cell.selected = NO;
    
    // コールバック
    [self callbackWithIndexPath:indexPath];
    
}


#pragma mark - Other

// セクション情報を追加する。
- (ZLSimpleSectionItem *)addSectionItemWithTitle:(NSString *)title
{
    ZLSimpleSectionItem *sectionItem = [[ZLSimpleSectionItem alloc] init];
    sectionItem.title = title;
    [_sectionItems addObject:sectionItem];
    
    return sectionItem;
}

// データソース（セクション情報）をクリアする。
- (void)clearDataSource
{
    _sectionItems = [[NSMutableArray alloc] init];
    
    [self.tableView reloadData];
}

#pragma mark - Other

// デフォルトセルを生成して返す
- (UITableViewCell *)cellForNormalWithInfo:(ZLSimpleCellItem *)cellItem
{
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kZLSimpleCellIdentifierSubtitle];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kZLSimpleCellIdentifierSubtitle];
    }
    
    [self setupCommonAppearanceForCell:&cell];
    [self setupCommonInfoForCell:&cell info:cellItem];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
    
}

// DisclosureIndicator型セルを生成して返す
- (UITableViewCell *)cellForDisclosureIndicatorWithInfo:(ZLSimpleCellItem *)cellItem
{
    
    UITableViewCell *cell = [self cellForNormalWithInfo:cellItem];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

// DetailDisclosureButton型セルを生成して返す
- (UITableViewCell *)cellForDetailDisclosureButtonWithInfo:(ZLSimpleCellItem *)cellItem
{
    
    UITableViewCell *cell = [self cellForNormalWithInfo:cellItem];
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    return cell;
}

// Checkmark型セルを生成して返す
- (UITableViewCell *)cellForCheckmarkWithInfo:(ZLSimpleCellItem *)cellItem
{
    
    UITableViewCell *cell = [self cellForNormalWithInfo:cellItem];
    
    BOOL isChecked = [cellItem.value boolValue];
    if (isChecked) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

// DetailButton型セルを生成して返す
- (UITableViewCell *)cellForDetailButtonWithInfo:(ZLSimpleCellItem *)cellItem
{
    
    UITableViewCell *cell = cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    
    [self setupCommonAppearanceForCell:&cell];
    [self setupCommonInfoForCell:&cell info:cellItem];
    
    cell.accessoryType = UITableViewCellAccessoryDetailButton;
    
    return cell;
    
}

// ラベル型セルを生成して返す
- (UITableViewCell *)cellForLabelWithInfo:(ZLSimpleCellItem *)cellItem
{
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kZLSimpleCellIdentifierValue1];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kZLSimpleCellIdentifierValue1];
    }
    
    UILabel *label = (UILabel *)cell.accessoryView;
    if (!label) {
        label = [[UILabel alloc] init];
        cell.accessoryView = label;
    }

    NSString *title = nil;
    if (cellItem.value) {
        title = [cellItem.value description];
    }

    label.text = title;
    [label sizeToFit];

    
    [self setupCommonAppearanceForCell:&cell];
    [self setupCommonInfoForCell:&cell info:cellItem];
    
    return cell;
    
}

// ボタン型セルを生成して返す
- (UITableViewCell *)cellForButtonWithInfo:(ZLSimpleCellItem *)cellItem
{
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kZLSimpleCellIdentifierButton];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kZLSimpleCellIdentifierButton];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    UIButton *button = (UIButton *)cell.accessoryView;
    if (!button) {
        button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button addTarget:self action:@selector(subControlTouch:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView = button;
    }
    
    NSString *title = @"Done";
    if (cellItem.value) {
        title = [cellItem.value description];
    }
    [button setTitle:title forState:UIControlStateNormal];
    [button sizeToFit];

    
    [self setupCommonAppearanceForCell:&cell];
    [self setupCommonInfoForCell:&cell info:cellItem];

    return cell;
}

// スイッチ型セルを生成して返す
- (UITableViewCell *)cellForSwitchWithInfo:(ZLSimpleCellItem *)cellItem
{
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kZLSimpleCellIdentifierSwitch];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kZLSimpleCellIdentifierSwitch];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    UISwitch *aSwitch = (UISwitch *)cell.accessoryView;
    if (!aSwitch) {
        aSwitch = [[UISwitch alloc] init];
        [aSwitch addTarget:self action:@selector(subControlValueChanged:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = aSwitch;
    }
    
    aSwitch.on = [cellItem.value boolValue];
    
    
    [self setupCommonAppearanceForCell:&cell];
    [self setupCommonInfoForCell:&cell info:cellItem];
    
    return cell;
}

// 任意のUIControlを追加したセルを生成して返す
- (UITableViewCell *)cellForAnyControlWithInfo:(ZLSimpleCellItem *)cellItem
{
    
    // セルの再利用はしない
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    UIControl *control = nil;
    if ([cellItem.content isKindOfClass:[UIControl class]]) {
        control = (UIControl *)cellItem.content;
    }
    
    if (control) {
        
        CGRect baseFrame = cell.contentView.frame;
        
        UILabel *valueLabel = nil;
        if ([control isKindOfClass:[UISlider class]]) {
            
            CGRect labelFrame = baseFrame;
            labelFrame.size.width = kValueLabelWidth;
            valueLabel = [[UILabel alloc] initWithFrame:labelFrame];
            valueLabel.lineBreakMode = NSLineBreakByClipping;
            valueLabel.textAlignment = NSTextAlignmentRight;
            valueLabel.font = [UIFont systemFontOfSize:kValueLabelFontSize];
            valueLabel.adjustsFontSizeToFitWidth = YES;
            valueLabel.minimumScaleFactor = 0.5f;
            
            [control addObserver:valueLabel forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:nil];
            
            CGFloat value = [[control valueForKey:@"value"] doubleValue];
            valueLabel.text = [self p_stringForReadableValue:value];
            
            cell.accessoryView = valueLabel;
        }
        
        CGFloat usableWidth = CGRectGetWidth(baseFrame) * kAnyControlWidthRatio;
        CGFloat controlMinX = CGRectGetWidth(baseFrame) - usableWidth;
        CGFloat accessoryWidth = CGRectGetWidth(valueLabel.frame) * kAnyControlWidthRatio;
        
        CGRect frame = baseFrame;
        frame.size.width = usableWidth - accessoryWidth;
        frame.size.width -= kControlMargin.left + kControlMargin.right;
        frame.size.height -= kControlMargin.top + kControlMargin.bottom;
        frame.origin.x = controlMinX + kControlMargin.left + accessoryWidth;
        frame.origin.y = (CGRectGetHeight(baseFrame) - CGRectGetHeight(frame)) / 2;
        frame = CGRectIntegral(frame);
        control.frame = frame;
        control.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [control addTarget:self action:@selector(subControlValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        [cell.contentView addSubview:control];

    }
    
    [self setupCommonAppearanceForCell:&cell];
    [self setupCommonInfoForCell:&cell info:cellItem];

    
    return cell;
}

// sliderの値をスナップする。
- (CGFloat)p_snapValueForSlider:(UISlider *)slider
{
    CGFloat snappedValue = slider.value;
    
    if (slider.maximumValue <= 1.0f) {
        snappedValue = (snappedValue * 100) / 100;
        
    } else if (slider.maximumValue <= 10.0f) {
        snappedValue = (snappedValue * 10) / 10;
        
    }
    
    return snappedValue;
}


// 値表示ラベルの更新
- (NSString *)p_stringForReadableValue:(CGFloat)value
{
    NSString *valueString = nil;
    
    if (value <= 1.0f) {
        valueString = [NSString stringWithFormat:@"%0.2f", value];
        
    } else if (value <= 10.0f) {
        valueString = [NSString stringWithFormat:@"%0.1f", value];
        
    } else {
        valueString = [NSString stringWithFormat:@"%0.0f", value];
    }

    return valueString;
}


// セルの外観を設定する
- (void)setupCommonAppearanceForCell:(UITableViewCell **)aCell
{
    UITableViewCell *cell = *aCell;
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.textColor = [UIColor darkGrayColor];
}

// セルに基本情報を設定する
- (void)setupCommonInfoForCell:(UITableViewCell **)aCell info:(ZLSimpleCellItem *)cellItem
{
    UITableViewCell *cell = *aCell;
    
    NSString *title = cellItem.title;
    NSString *detail = cellItem.detail;
    NSInteger tag = cellItem.tag;

    cell.textLabel.text = title;
    cell.detailTextLabel.text = detail;
    cell.tag = tag;
}

// 指定されたindexPathにマッチするセル情報を返す
- (ZLSimpleCellItem *)cellItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZLSimpleSectionItem *sectionItem = nil;
    ZLSimpleCellItem *cellItem = nil;
    
    if (_sectionItems.count >= indexPath.section) {
        sectionItem = _sectionItems[indexPath.section];
        if (sectionItem.cellItems.count >= indexPath.row) {
            cellItem = sectionItem.cellItems[indexPath.row];
        }
    }
    
    return cellItem;
}

// 指定されたタグのセル情報を返す。
- (ZLSimpleCellItem *)cellItemWithTag:(NSInteger)tag
{
    ZLSimpleCellItem *targetCellItem = nil;
    
    for (ZLSimpleSectionItem *sectionItem in _sectionItems) {
        targetCellItem = [sectionItem cellItemWithTag:tag];
        if (targetCellItem) {
            break;
        }
    }
    
    return targetCellItem;
}

// セル情報に設定されたアクション、コールバックを実行する。
- (void)callbackWithIndexPath:(NSIndexPath *)indexPath
{
    ZLSimpleCellItem *cellItem = [self cellItemAtIndexPath:indexPath];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    // cellItemのアクションを実行
    if (cellItem.target && (cellItem.action != NULL)) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [cellItem.target performSelector:cellItem.action withObject:cellItem];
#pragma clang diagnostic pop
    }
    
    // cellItemのコールバックを実行
    if (cellItem.callback) {
        cellItem.callback(cellItem, cell);
    }
    
}

// cellにaddしたコントロールがタッチされた時に呼ばれる。
- (void)subControlTouch:(UIControl *)control
{
    // cell取得
    UITableViewCell *cell = [self cellForContainedView:control];
    if (!cell) {
        return;
    }
    
    // cellItem取得
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    // コールバック
    [self callbackWithIndexPath:indexPath];
}

// cellにaddしたコントロールの値が変更された時に呼ばれる。
- (void)subControlValueChanged:(UIControl *)control
{
    // cell取得
    UITableViewCell *cell = [self cellForContainedView:control];
    if (!cell) {
        return;
    }
    
    // cellItem取得
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ZLSimpleCellItem *cellItem = [self cellItemAtIndexPath:indexPath];
    
    // cellItemの値を更新
    if ([control isKindOfClass:[UISwitch class]]) {
        cellItem.value = @([(UISwitch *)control isOn]);
    }
    
    // sliderの場合はスナップ
    if ([control isKindOfClass:[UISlider class]]) {
        UISlider *slider = (UISlider *)control;
        slider.value = [self p_snapValueForSlider:slider];
    }
    
    // コールバック
    [self callbackWithIndexPath:indexPath];
    
}

// 指定されたviewをaddしているcellを返す
- (UITableViewCell *)cellForContainedView:(UIView *)view
{
    if (![view isKindOfClass:[UIView class]]) {
        return nil;
    }
    
    UIView *testView = view;
    do {
        if ([testView isKindOfClass:[UITableViewCell class]]) {
            return (UITableViewCell *)testView;
        }
        testView = [testView superview];
    } while ([testView isDescendantOfView:self.tableView]);
    
    return nil;
}


// セクション情報リストを設定（オーバーライド用）する。
- (void)setupSectionItem
{
    
    // 実装サンプル兼テスト
/*
    ZLSimpleSectionItem *section0 = [self addSectionItemWithTitle:@"Normal"];
    
    [section0 addCellItemWithTitle:@"Normal-Selector"
                            detail:@"This cell is Normal-Selector"
                            target:self
                            action:@selector(showTestAlert:)];
    
    [section0 addCellItemWithTitle:@"Normal-Block"
                            detail:@"This cell is Normal-Block"
                          callback:^(ZLSimpleCellItem *cellItem, UITableViewCell *cell)
    {
        [self showTestAlert:cellItem];
    }];
*/
    
}

@end
