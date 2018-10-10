//
//  BLOptionalVeiw.m
//  BLSinaNewsSliderViewControllerDemo
//
//  Created by boundlessocean on 2016/12/23.
//  Copyright © 2016年 ocean. All rights reserved.
//

#import "BLOptionalVeiw.h"
#import "BLTitleItem.h"
#import "BLSliderView.h"
@interface BLOptionalVeiw ()
/** 滑动条 */
@property (nonatomic, strong) BLSliderView *sliderView;
@property (nonatomic, strong) UIView *lineView;
@end

static const CGFloat sliderViewWidth = 15;
#define kItemWidth [UIScreen mainScreen].bounds.size.width/2
//#define sliderViewWidth SCREEN_WIDTH/2
//static const CGFloat itemWidth = 60;
@implementation BLOptionalVeiw

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.sliderView];
        [self addSubview:self.lineView];
        /** 监听frame改变 */
        [self addObserver:self forKeyPath:@"_sliderView.frame" options:NSKeyValueObservingOptionNew context:nil];
        
    }
    return self;
}

/** 接收通知 */
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context{
    CGFloat itemVisionblePositionMax = _sliderView.frame.origin.x - (kItemWidth - sliderViewWidth)/2 + 2*kItemWidth;
    CGFloat itemVisionblePositionMin = _sliderView.frame.origin.x - (kItemWidth - sliderViewWidth)/2 - kItemWidth;
    
    // 右滑
    if (itemVisionblePositionMax >= self.frame.size.width + self.contentOffset.x &&
        itemVisionblePositionMax <= self.contentSize.width) {
        [UIView animateWithDuration:0.2 animations:^{
            self.contentOffset = CGPointMake(itemVisionblePositionMax - self.frame.size.width, 0);
        }];
    }
    // 左滑
    if (itemVisionblePositionMin < self.contentOffset.x &&
        itemVisionblePositionMin >= 0) {
        [UIView animateWithDuration:0.2 animations:^{
            self.contentOffset = CGPointMake(itemVisionblePositionMin, 0);
        }];
    }
}

#pragma mark - - set

- (void)setTitleArray:(NSArray<NSString *> *)titleArray{
    _titleArray = titleArray;
    
    // 添加所有item
    for (NSInteger i = 0; i < titleArray.count; i++) {
        BLTitleItem *item = [[BLTitleItem alloc] initWithFrame:CGRectMake(i*kItemWidth, 0, kItemWidth, self.frame.size.height)];
        [item addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
        [item setTitle:titleArray[i] forState:UIControlStateNormal];
        item.titleLabel.font = [UIFont systemFontOfSize:15];
        [item setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        item.tag = i + 100;
        [self addSubview:item];
    }
    
    // 第一个item 更改样式
    BLTitleItem *firstItem = [self viewWithTag:100];
    [firstItem setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    firstItem.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    
    self.contentSize = CGSizeMake(kItemWidth*titleArray.count, self.frame.size.height);
}

- (void)setContentOffSetX:(CGFloat)contentOffSetX{
    _contentOffSetX = contentOffSetX;
    NSInteger index = (NSInteger)contentOffSetX / (NSInteger)[UIScreen mainScreen].bounds.size.width;
    // progress 0(屏幕边缘开始) -  1 （满屏结束）
    CGFloat progress =( _contentOffSetX - index * [UIScreen mainScreen].bounds.size.width )/ [[UIScreen mainScreen]bounds].size.width;
    // 左右选项卡（item）
    BLTitleItem *leftItem = [self viewWithTag:index + 100];
    BLTitleItem *rightItem = [self viewWithTag:index + 101];
    // item 根据progress改变状态
    leftItem.progress = 1 - progress;
    rightItem.progress = progress;
    // 滑条sliderView 根据progress 改变状态
    CGRect frame = _sliderView.frame;
    frame.origin.x = index * kItemWidth + (kItemWidth - sliderViewWidth)/2;
    _sliderView.frame = frame;
    _sliderView.progress = progress;
}

#pragma mark - - lazy load

- (BLSliderView *)sliderView{
    if (!_sliderView) {
        _sliderView = [[BLSliderView alloc] initWithFrame:CGRectMake((kItemWidth - sliderViewWidth)/2, self.frame.size.height - 2, sliderViewWidth, 2)];
        _sliderView.backgroundColor = [UIColor redColor];
        _sliderView.layer.cornerRadius = 2;
        _sliderView.layer.masksToBounds = YES;
        _sliderView.itemWidth = kItemWidth;
        _sliderView.sliderWidth = sliderViewWidth;
    }
    return _sliderView;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor colorWithRed:224/255 green:224/255 blue:224/255 alpha:1];
        _lineView.frame = CGRectMake(0, self.frame.size.height-0.5, self.frame.size.width, 0.5);
    }
    return _lineView;
}


#pragma mark - - button event

- (void)itemClicked:(BLTitleItem *)sender{
    NSInteger index = (NSInteger)_contentOffSetX / (NSInteger)[UIScreen mainScreen].bounds.size.width;
    if (sender.tag - 100 == index) return;
    BLTitleItem *currentItem = [self viewWithTag:index + 100];
    
    [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [currentItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    CGRect frame = _sliderView.frame;
    frame.origin.x = (sender.tag - 100) * kItemWidth + (kItemWidth - sliderViewWidth)/2;
    
    [UIView animateWithDuration:0.2 animations:^{
        sender.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
        currentItem.transform = CGAffineTransformIdentity;
        _sliderView.frame = frame;
    }];
    !_titleItemClickedCallBackBlock ? : _titleItemClickedCallBackBlock(sender.tag);
}

@end
