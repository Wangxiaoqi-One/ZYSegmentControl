//
//  ZYPagesView.h
//  ZYSegement
//
//  Created by 三小时梦想 on 2020/9/7.
//  Copyright © 2020 三小时梦想. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZYPagesViewDelegate <NSObject>

@optional
- (void)pageViewDidScrollToindex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ZYPagesView : UIView

@property(weak, nonatomic)id<ZYPagesViewDelegate> delegate;

+ (instancetype)initWithFrame:(CGRect)frame children:(NSArray<UIView *> *)children;

- (void)setSelectPageIndexAt:(NSInteger)index animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
