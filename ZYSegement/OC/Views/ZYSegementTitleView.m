//
//  ZYSegementTitleView.m
//  ZYSegement
//
//  Created by 三小时梦想 on 2020/9/4.
//  Copyright © 2020 三小时梦想. All rights reserved.
//

#import "ZYSegementTitleView.h"
#import "ZYSegementTitleCell.h"

@interface ZYSegementTitleView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, assign) CGFloat titleTotalWidth;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) UIView *indicatorView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableDictionary *indicatorRects;
@property (nonatomic, strong) NSMutableArray *titleSizes;


@end

static NSString *CELLID = @"CELLID";

@implementation ZYSegementTitleView

- (void)layoutSubviews{
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
    [self setupSegmentTitleView];
}

#pragma mark -- 初始化方法
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setDefaultConfig];
        [self initSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withTitles:(NSArray *)titles{
    self = [super initWithFrame:frame];
    if (self) {
        [self setDefaultConfig];
        self.titles = titles;
        [self initSubViews];
    }
    return self;
}

#pragma mark -- 基本配置
- (void)setDefaultConfig{
    self.normalColor = [UIColor blackColor];
    self.selectColor = [UIColor redColor];
    self.font = [UIFont systemFontOfSize:16.0];
    self.indicatorScale = 0.6;
    self.titleSpace = 0.0;
    self.isHideSeparatorLine = YES;
    self.selectedIndex = 0;
    self.isTitleZoom = NO;
    self.titleSelectedFontScale = 1.2;
}

- (void)initSubViews{
    [self addSubview:self.collectionView];
    [self.collectionView addSubview:self.indicatorView];
}

#pragma mark -- setter

- (void)setNormalColor:(UIColor *)normalColor{
    _normalColor = normalColor;
    if (self.titles) {
        //属性刷新
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    }
}

- (void)setSelectColor:(UIColor *)selectColor{
    _selectColor = selectColor;
    _indicatorView.backgroundColor = _selectColor;
    if (self.titles) {
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    }
}

- (void)setIsHideSeparatorLine:(BOOL)isHideSeparatorLine{
    _isHideSeparatorLine = isHideSeparatorLine;
    if (self.titles) {
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    }
}

- (void)setIsTitleZoom:(BOOL)isTitleZoom{
    _isTitleZoom = isTitleZoom;
    if (self.titles) {
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    }
}

- (void)setTitleSelectedFontScale:(CGFloat)titleSelectedFontScale{
    _titleSelectedFontScale = titleSelectedFontScale;
    if (self.titles) {
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    }
}

- (void)setFont:(UIFont *)font{
    _font = font;
    [self setupSegmentTitleView];
}

- (void)setTitles:(NSArray *)titles{
    _titles = titles;
    [self setupSegmentTitleView];
}

- (void)setIndicatorScale:(CGFloat)indicatorScale{
    _indicatorScale = indicatorScale;
    [self setupSegmentTitleView];
}

- (void)setTitleSpace:(CGFloat)titleSpace{
    _titleSpace = titleSpace;
    [self setupSegmentTitleView];
}

// 标题数组，间距，字体大小发生变化都需要重新调用这个方法
- (void)setupSegmentTitleView{
    if (self.titles != nil ) {
        [self.titleSizes removeAllObjects];
        [self.indicatorRects removeAllObjects];
        self.titleTotalWidth = [self getTitlesTotalWidth:self.titles];
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        [self setSelectIndexAt:self.selectedIndex withAnimated:NO];
    }
}

#pragma mark -- customMethod

// 设置选项
- (void)setSelectIndexAt:(NSInteger)index withAnimated:(BOOL)animated{
    __weak typeof(self) weakself = self;
    [self.collectionView performBatchUpdates:^{
        [weakself setSelectedCellAt:index animated:animated];
        [weakself setSelectedIndicatorAt:index animated:animated];
    } completion:nil];
}


//设置选中cell
- (void)setSelectedCell:(ZYSegementTitleCell *)cell at:(NSIndexPath *)indexPath animated:(BOOL)animated{
    self.selectedIndex = indexPath.item;
    NSIndexPath *seleIndexPath = indexPath;
    ZYSegementTitleCell *seleCell =  (ZYSegementTitleCell*)[self.collectionView cellForItemAtIndexPath:seleIndexPath];
    for (ZYSegementTitleCell *subCell in self.collectionView.visibleCells) {
        if (subCell == cell) {
            [subCell updateCellTitle:YES];
        }
        else if (subCell == seleCell) {
            [subCell updateCellTitle:false];
        }
        else {
            [subCell updateCellTitle:false];
        }
    }
    [self.collectionView selectItemAtIndexPath:indexPath animated:animated scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
}

- (void)setSelectedCellAt:(NSInteger)index animated:(BOOL)animated{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    ZYSegementTitleCell *cell = (ZYSegementTitleCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
    [self setSelectedCell:cell at:indexPath animated:animated];
}


//设置选中指示器
- (void)setSelectedIndicatorForCell:(ZYSegementTitleCell *)cell at:(NSInteger)index animated:(BOOL)animated{
    CGRect indicatorFrame = [self rectIndicatoForCell:cell index:index];
    if (animated) {
        [UIView animateWithDuration:0.5 animations:^{
            self.indicatorView.frame = indicatorFrame;
        }];
    } else {
        self.indicatorView.frame = indicatorFrame;
    }
}

- (void)setSelectedIndicatorAt:(NSInteger)index animated:(BOOL)animated{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    ZYSegementTitleCell *cell = (ZYSegementTitleCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
    if (cell == nil) {
        return;
    }
    [self setSelectedIndicatorForCell:cell at:index animated:animated];
}



#pragma mark --  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.titles.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZYSegementTitleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELLID forIndexPath:indexPath];
    cell.isChecked = (indexPath.item == self.selectedIndex);
    cell.font = self.font;
    cell.selectColor = self.selectColor;
    cell.normalColor = self.normalColor;
    cell.isTitleZoom = self.isTitleZoom;
    cell.titleSelectedFontScale = self.titleSelectedFontScale;
    if (self.isHideSeparatorLine) {
        cell.isHideLeftline = self.isHideSeparatorLine;
    } else {
        cell.isHideLeftline = indexPath.item == 0 ? YES : NO;
    }
    if (self.titles.count > 0) {
        cell.title = self.titles[indexPath.item];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self setSelectedCellAt:indexPath.item animated:YES];
    [self setSelectedIndicatorAt:indexPath.item animated:NO];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(segementTitleViewDidSelectIndex:)]) {
        [self.delegate segementTitleViewDidSelectIndex:indexPath.item];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.titles == nil) {
        return CGSizeZero;
    }
    return [self getCellSizeAtIndex:indexPath.row];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (self.titles == nil) {
        return UIEdgeInsetsZero;
    }
    return [self getSectionEdgeInsets];
}


#pragma mark --lazyloading

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[ZYSegementTitleCell class] forCellWithReuseIdentifier:CELLID];
    }
    return _collectionView;
}

- (UIView *)indicatorView{
    if (!_indicatorView) {
        _indicatorView = [[UIView alloc] initWithFrame:CGRectZero];
        _indicatorView.backgroundColor = [UIColor redColor];
        _indicatorView.layer.cornerRadius = 1.5;
    }
    return _indicatorView;
}

- (NSMutableDictionary *)indicatorRects{
    if (!_indicatorRects) {
        _indicatorRects = [NSMutableDictionary new];
    }
    return _indicatorRects;
}

- (NSMutableArray *)titleSizes{
    if (!_titleSizes) {
        _titleSizes = [NSMutableArray new];
    }
    return _titleSizes;
}

#pragma mark -- 工具方法

//获取标题总宽度

- (CGFloat)getTitlesTotalWidth:(NSArray *)titles{
    CGFloat totalWidth = 0.0;
    for (int i = 0; i < titles.count; i++) {
        CGSize size = [self getTextSizeWithText:titles[i] andFont:self.font];
        NSValue *value = [NSValue valueWithCGSize:size];
        [self.titleSizes addObject:value];
        totalWidth += size.width;
    }
    return totalWidth;
}

//获取单个标题宽度
- (CGSize)getTextSizeWithText:(NSString *)text andFont:(UIFont *)font{
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:font}];
    return size;
}

//获取cell大小
- (CGSize)getCellSizeAtIndex:(NSInteger)index{
    CGFloat height = self.collectionView.frame.size.height;
    CGFloat width = 0.0;
    CGSize size = [self.titleSizes[index] CGSizeValue];
    if (self.titleSpace == 0.0) {
        if (self.titleTotalWidth < self.collectionView.frame.size.width) {
            CGFloat distance = (self.collectionView.frame.size.width - self.titleTotalWidth) / self.titles.count;
            width = size.width + distance;
        }
    } else {
        width = size.width + self.titleSpace;
    }
    return CGSizeMake(width, height);
}

//获取指示器位置

- (CGRect)rectIndicatoForCell:(ZYSegementTitleCell *)cell index:(NSInteger)index{
    NSString *ind = [NSString stringWithFormat:@"%ld", index];
    if(self.indicatorRects[ind] != nil){
        NSValue *value = self.indicatorRects[ind];
        CGRect rect;
        [value getValue:&rect];
        return rect;
    }
    CGSize titleSize = [self.titleSizes[index] CGSizeValue];;
    CGFloat width = titleSize.width * self.indicatorScale;
    CGFloat height = 3.0;
    if (width > cell.frame.size.width) {
        width = cell.frame.size.width;
    }
    
    CGFloat left = cell.frame.origin.x + (cell.frame.size.width - width) * 0.5;
    CGFloat top = self.collectionView.frame.size.height - 3.0;
    
    CGRect rect = CGRectMake(left, top, width, height);

    NSValue *value = [NSValue valueWithCGRect:rect];
    [self.indicatorRects setValue:value forKey:ind];
    return rect;
}

//获取分区偏移量
- (UIEdgeInsets)getSectionEdgeInsets{
    CGFloat totalWidth = self.titles.count * self.titleSpace + self.titleTotalWidth;
    CGFloat sectionMargin = 0.0;
    if (totalWidth < self.collectionView.frame.size.width) {
        CGFloat differenceW = self.collectionView.frame.size.width - totalWidth;
        sectionMargin = differenceW * 0.5;
        if (self.titleSpace == 0.0) {
            sectionMargin = 0.0;
        }
    }
    return UIEdgeInsetsMake(0, sectionMargin, 0, sectionMargin);
}


@end
