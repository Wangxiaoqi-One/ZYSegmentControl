//
//  OCViewController.m
//  ZYSegement
//
//  Created by 三小时梦想 on 2020/11/6.
//  Copyright © 2020 三小时梦想. All rights reserved.
//

#define KSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define KSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#import "OCViewController.h"
#import "ZYSegement-Swift.h"
#import "ZYSegementTitleView.h"
#import <Masonry/Masonry.h>

@interface OCViewController ()

@property (nonatomic, strong) ZYSegementTitleView *titleView;
@property (nonatomic, copy) NSArray *titles;

@end

@implementation OCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;
    [self.view addSubview:self.titleView];
    
    __weak typeof(self) weakSelf = self;
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(50);
    }];
    _titleView.titles = self.titles;
    
}

- (ZYSegementTitleView *)titleView{
    if (!_titleView) {
        _titleView = [[ZYSegementTitleView alloc] initWithFrame:CGRectZero];
    }
    return _titleView;
}

- (NSArray *)titles{
    if (!_titles) {
        _titles = @[@"全部订单", @"待付款", @"待收货", @"待发货", @"售后服务", @"评价"];
    }
    return _titles;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
