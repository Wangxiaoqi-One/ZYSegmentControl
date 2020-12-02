//
//  ZYSegementTitleCell.h
//  ZYSegement
//
//  Created by mac on 2020/9/6.
//  Copyright © 2020 三小时梦想. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYSegementTitleCell : UICollectionViewCell

@property (assign, nonatomic) BOOL isChecked;
@property (assign, nonatomic) BOOL isHideLeftline;
@property (copy, nonatomic) NSString *title;
@property (strong, nonatomic) UIColor *normalColor;
@property (strong, nonatomic) UIColor *selectColor;
@property (strong, nonatomic) UIFont *font;
@property (nonatomic, assign) BOOL isTitleZoom;
@property (nonatomic, assign) CGFloat titleSelectedFontScale;

- (void)updateCellTitle:(BOOL)isChecked;

@end

NS_ASSUME_NONNULL_END
