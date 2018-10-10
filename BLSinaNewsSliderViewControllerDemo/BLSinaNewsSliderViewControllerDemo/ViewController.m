//
//  ViewController.m
//  BLSinaNewsSliderViewControllerDemo
//
//  Created by boundlessocean on 2016/12/23.
//  Copyright © 2016年 ocean. All rights reserved.
//

#import "ViewController.h"
#import "BLSliderViewController.h"
#import "LLViewController.h"
@interface ViewController ()<BLSliderViewControllerDataSource>
/** 滑动选项 */
@property (nonatomic, strong) BLSliderViewController *sliderVC;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    [self addChildViewController:_sliderVC];
    [self.view addSubview:_sliderVC.view];
}

#pragma mark - - lazy load
- (BLSliderViewController *)sliderVC{
    if (!_sliderVC) {
        _sliderVC = [BLSliderViewController new];
        _sliderVC.dataSource = self;
    }
    return _sliderVC;
}

#pragma mark - - BLSliderViewControllerDataSource
- (NSArray<NSString *> *)bl_titlesArrayInSliderViewController{
    return @[@"打开",@"温柔",@"权威",@"藕片",@"风格",@"链接",@"电视",@"快乐",@"漂亮",@"配合",@"瓯海",@"提升"];
}

- (UIViewController *)bl_sliderViewController:(BLSliderViewController *)sliderVC subViewControllerAtIndxe:(NSInteger)index{
    return [LLViewController new];
}

- (CGFloat)bl_optionalViewStartYInSliderViewController{
    return 40;
}

- (CGFloat)bl_viewOfChildViewControllerHeightInSliderViewController{
    return self.view.frame.size.height - 40 - 40;
}
@end
