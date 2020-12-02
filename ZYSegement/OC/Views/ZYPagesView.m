//
//  ZYPagesView.m
//  ZYSegement
//
//  Created by 三小时梦想 on 2020/9/7.
//  Copyright © 2020 三小时梦想. All rights reserved.
//

#import "ZYPagesView.h"


@interface ZYPagesView ()<UIScrollViewDelegate>

@property(nonatomic, strong) UIScrollView *pageViews;

@end

@implementation ZYPagesView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)initWithFrame:(CGRect)frame children:(NSArray<UIView *> *)children{
    ZYPagesView *pageView = [[ZYPagesView alloc] initWithFrame:frame children:children];
    return pageView;
}


- (instancetype)initWithFrame:(CGRect)frame children:(NSArray<UIView *> *)children{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


- (void)initSubViewsWithChildren:(NSArray *)children{
    [self addSubview:self.pageViews];
    self.pageViews.contentSize = CGSizeMake(children.count * self.frame.size.width, self.frame.size.height);
    for (int i = 0; i < children.count; i++) {
        UIView *view = (UIView *)children[i];
        view.frame = CGRectMake(i * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        [self.pageViews addSubview:view];
    }
}

- (void)setSelectPageIndexAt:(NSInteger)index animated:(BOOL)animated{
    CGPoint offset = CGPointMake(self.frame.size.width * index, 0);
    [self.pageViews setContentOffset:offset animated:animated];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat width = scrollView.frame.size.width;
    NSInteger selectIndex = offsetX / width;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageViewDidScrollToindex:)]) {
        [self.delegate pageViewDidScrollToindex:selectIndex];
    }
    
}

- (UIScrollView *)pageViews{
    if (!_pageViews) {
        _pageViews = [[UIScrollView alloc] initWithFrame:self.bounds];
        _pageViews.pagingEnabled = YES;
        _pageViews.bounces = NO;
        _pageViews.delegate = self;
    }
    return _pageViews;
}



@end
