//
//  ZYSegementTitleView.h
//  ZYSegement
//
//  Created by 三小时梦想 on 2020/9/4.
//  Copyright © 2020 三小时梦想. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZYSegementTitleViewDelegate <NSObject>

@optional
- (void)segementTitleViewDidSelectIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_BEGIN


@interface ZYSegementTitleView : UIView

@property(assign, nonatomic) id<ZYSegementTitleViewDelegate> delegate;

/// 标题数组
@property (nonatomic, copy) NSArray *titles;
/// 普通颜色
@property (nonatomic, strong) UIColor *normalColor;
/// 选中颜色
@property (nonatomic, strong) UIColor *selectColor;
/// 字体大小
@property (nonatomic, strong) UIFont *font;
/// 指示器宽度 范围：文字宽度的比例，最大为文字宽度+文字间距 1.0与文字等宽
@property (nonatomic, assign) CGFloat indicatorScale;
/// 标题之间的间距
@property (nonatomic, assign) CGFloat titleSpace;
/// 分割线
@property (nonatomic, assign) BOOL isHideSeparatorLine;
/// 是否让标题文字具有缩放效果
@property (nonatomic, assign) BOOL isTitleZoom;
/// 标题选中时的缩放比例
@property (nonatomic, assign) CGFloat titleSelectedFontScale;



- (instancetype)initWithFrame:(CGRect)frame withTitles:(NSArray *)titles;

- (void)setSelectIndexAt:(NSInteger)index withAnimated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
