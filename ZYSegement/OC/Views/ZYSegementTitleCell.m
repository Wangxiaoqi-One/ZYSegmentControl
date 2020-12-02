//
//  ZYSegementTitleCell.m
//  ZYSegement
//
//  Created by mac on 2020/9/6.
//  Copyright © 2020 三小时梦想. All rights reserved.
//

#import "ZYSegementTitleCell.h"
#import <Masonry.h>

@interface ZYSegementTitleCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *rightLine;

@end

@implementation ZYSegementTitleCell


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.rightLine];
    
//    self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    //取消自动转换约束
//    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.rightLine.translatesAutoresizingMaskIntoConstraints = NO;

//    //NSLayoutConstraint 约束
//    NSLayoutConstraint *margin_top = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
//
//    NSLayoutConstraint *margin_left = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
//
//    NSLayoutConstraint *margin_bottom = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
//
//    NSLayoutConstraint *margin_right = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0.0];
//
//    [self addConstraints:@[margin_top, margin_left, margin_bottom, margin_right]];
    //VFL 约束布局

    //绑定视图
    NSDictionary *views = @{@"rightLine":self.rightLine};

    //设置参数字典 变量数值动态化
    NSDictionary *metris = @{
        @"rightLineTop":@(15),
        @"rightLineLeft":@(0),
        @"rightLineBottom":@(15),
        @"rightLineWidth":@(1)
    };

    //水平方向的约束
    NSArray<NSLayoutConstraint *> *rightLineHContraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-rightLineLeft-[rightLine(==rightLineWidth)]" options:0 metrics:metris views:views];
    // 垂直方向的约束
    NSArray<NSLayoutConstraint *> *rightLineVContraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-rightLineTop-[rightLine]-rightLineBottom-|" options:0 metrics:metris views:views];

    [self addConstraints:rightLineHContraints];
    [self addConstraints:rightLineVContraints];
    
}

#pragma mark -- setter
- (void)setIsChecked:(BOOL)isChecked{
    _isChecked = isChecked;
    self.titleLabel.textColor = _isChecked ? [UIColor redColor] : [UIColor blackColor];
}

- (void)setIsHideLeftline:(BOOL)isHideLeftline{
    self.rightLine.hidden = isHideLeftline;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
}

- (void)setNormalColor:(UIColor *)normalColor{
    _normalColor = normalColor;
    self.titleLabel.textColor = _normalColor;
}

- (void)setSelectColor:(UIColor *)selectColor{
    _selectColor = selectColor;
}

- (void)setFont:(UIFont *)font{
    self.titleLabel.font = font;
}

-(void)setIsTitleZoom:(BOOL)isTitleZoom{
    _isTitleZoom = isTitleZoom;
}

- (void)setTitleSelectedFontScale:(CGFloat)titleSelectedFontScale{
    _titleSelectedFontScale = titleSelectedFontScale;
}

#pragma mark -- customMethod

- (void)updateCellTitle:(BOOL)isChecked{
    _isChecked = isChecked;
    self.titleLabel.textColor = isChecked ? self.selectColor : self.normalColor;
    CGAffineTransform transform = isChecked ? CGAffineTransformMakeScale(self.titleSelectedFontScale, self.titleSelectedFontScale) : CGAffineTransformIdentity;
    if (self.isTitleZoom) {
        [UIView animateWithDuration:0.3 animations:^{
            self.titleLabel.transform = transform;
        }];
    }
    
}

#pragma mark -- getter

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIView *)rightLine{
    if (!_rightLine) {
        _rightLine = [[UIView alloc] initWithFrame:CGRectZero];
        _rightLine.backgroundColor = [UIColor colorWithRed:233 / 255.0 green:233 / 255.0 blue:233 / 255.0 alpha:1.0];
    }
    return _rightLine;
}

@end
