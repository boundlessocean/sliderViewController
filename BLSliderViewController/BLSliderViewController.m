//
//  BLSliderViewController.m
//  BLSinaNewsSliderViewControllerDemo
//
//  Created by boundlessocean on 2016/12/23.
//  Copyright © 2016年 ocean. All rights reserved.
//

#import "BLSliderViewController.h"
#import "BLOptionalVeiw.h"


@interface BLSliderViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) BLOptionalVeiw *optionalView;
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) NSArray<NSString *> *titleArray;
@end

static const CGFloat optionalViewHeight = 40.0;

@implementation BLSliderViewController
{
    /** 缓存VC index */
    NSMutableArray<NSNumber *> *_cacheVCIndex;
}
- (void)dealloc{
    [self removeObserver:_optionalView forKeyPath:@"_optionalView.sliderView.frame"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    /** 添加子视图 */
    [self initSubViews];
    /** 处理事件回调 */
    [self dealButtonCallBackBlcok];
}

/** 添加子视图 */
- (void)initSubViews{
    _cacheVCIndex = [NSMutableArray arrayWithCapacity:0];
    self.view.frame = CGRectMake(self.view.frame.origin.x, [self getOptionalStartY], self.view.frame.size.width, optionalViewHeight + [self getScrollViewHeight]);
    
    [self.view addSubview:self.optionalView];
    [self.view addSubview:self.mainScrollView];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initializeSubViewControllerAtIndex:0];
    
    self.mainScrollView.contentSize = CGSizeMake(_titleArray.count *self.view.frame.size.width, self.mainScrollView.frame.size.height);
}

/** 处理事件回调 */
- (void)dealButtonCallBackBlcok{
    __weak BLSliderViewController *weakSelf = self;
    _optionalView.titleItemClickedCallBackBlock = ^(NSInteger index){
        weakSelf.mainScrollView.contentOffset = CGPointMake((index - 100) * self.view.frame.size.width , 0);
    };
}

#pragma mark - - lazy load

- (BLOptionalVeiw *)optionalView{
    if (!_optionalView) {
        _optionalView = [[BLOptionalVeiw alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, optionalViewHeight)];
        _optionalView.titleArray = self.titleArray;
    }
    return _optionalView;
}

- (UIScrollView *)mainScrollView{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.optionalView.frame), self.view.frame.size.width, [self getScrollViewHeight])];
        _mainScrollView.delegate = self;
        _mainScrollView.showsVerticalScrollIndicator = NO;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.bounces = NO;
    }
    return _mainScrollView;
}

- (NSArray *)titleArray{
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(bl_titlesArrayInSliderViewController)]) {
        _titleArray = [self.dataSource bl_titlesArrayInSliderViewController];
    }
    return _titleArray;
}

#pragma mark - - scrollView
/** 偏移量控制显示状态 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x / (scrollView.frame.size.width - 1);
    if (scrollView.contentOffset.x > 0) {
        [self.view endEditing:YES];
    }
    
    self.optionalView.contentOffSetX = scrollView.contentOffset.x;
    if (index == 0) return;
    [self initializeSubViewControllerAtIndex:index];
}

#pragma mark - - private

- (CGFloat)getOptionalStartY{
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(bl_optionalViewStartYInSliderViewController)]) {
        return [self.dataSource bl_optionalViewStartYInSliderViewController];
    }else{
        return 20;
    }
}

- (CGFloat)getScrollViewHeight{
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(bl_viewOfChildViewControllerHeightInSliderViewController)]) {
        return [self.dataSource bl_viewOfChildViewControllerHeightInSliderViewController];
    }else{
        return [UIScreen mainScreen].bounds.size.height - optionalViewHeight - 20;
    }
}

- (void)initializeSubViewControllerAtIndex:(NSInteger)index{
    
    // 添加子控制器
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(bl_sliderViewController:subViewControllerAtIndxe:)]) {
        UIViewController *vc = [self.dataSource bl_sliderViewController:self subViewControllerAtIndxe:index];
        if (![_cacheVCIndex containsObject:[NSNumber numberWithInteger:index]]) {
            [_cacheVCIndex addObject:[NSNumber numberWithInteger:index]];
            vc.view.frame = CGRectMake(index * vc.view.frame.size.width, 0, vc.view.frame.size.width , self.mainScrollView.frame.size.height);
            [self addChildViewController:vc];
            [self.mainScrollView addSubview:vc.view];
        }
    }
}

@end
