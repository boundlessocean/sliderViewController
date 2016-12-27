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

@end

static const CGFloat sliderViewWidth = 15;
static const CGFloat itemWidth = 60;
@implementation BLOptionalVeiw

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.sliderView];
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
    CGFloat itemVisionblePositionMax = _sliderView.frame.origin.x - (itemWidth - sliderViewWidth)/2 + 2*itemWidth;
    CGFloat itemVisionblePositionMin = _sliderView.frame.origin.x - (itemWidth - sliderViewWidth)/2 - itemWidth;
    
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
        BLTitleItem *item = [[BLTitleItem alloc] initWithFrame:CGRectMake(i*itemWidth, 0, itemWidth, self.frame.size.height)];
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
    
    self.contentSize = CGSizeMake(itemWidth*titleArray.count, self.frame.size.height);
}

- (void)setContentOffSetX:(CGFloat)contentOffSetX{
    _contentOffSetX = contentOffSetX;
    NSInteger index = (NSInteger)contentOffSetX / (NSInteger)[UIScreen mainScreen].bounds.size.width;
    CGFloat progress =( _contentOffSetX - index * [UIScreen mainScreen].bounds.size.width )/ [[UIScreen mainScreen]bounds].size.width;
    BLTitleItem *leftItem = [self viewWithTag:index + 100];
    BLTitleItem *rightItem = [self viewWithTag:index + 101];
    leftItem.progress = 1 - progress;
    rightItem.progress = progress;
    CGRect frame = _sliderView.frame;
    frame.origin.x = index * itemWidth + (itemWidth - sliderViewWidth)/2;
    _sliderView.frame = frame;
    _sliderView.progress = progress;
}

#pragma mark - - lazy load

- (BLSliderView *)sliderView{
    if (!_sliderView) {
        _sliderView = [[BLSliderView alloc] initWithFrame:CGRectMake((itemWidth - sliderViewWidth)/2, self.frame.size.height - 4, sliderViewWidth, 2)];
        _sliderView.backgroundColor = [UIColor redColor];
        _sliderView.layer.cornerRadius = 2;
        _sliderView.layer.masksToBounds = YES;
        _sliderView.itemWidth = itemWidth;
    }
    return _sliderView;
}


#pragma mark - - button event

- (void)itemClicked:(BLTitleItem *)sender{
    NSInteger index = (NSInteger)_contentOffSetX / (NSInteger)[UIScreen mainScreen].bounds.size.width;
    if (sender.tag - 100 == index) return;
    BLTitleItem *currentItem = [self viewWithTag:index + 100];
    
    [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [currentItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    CGRect frame = _sliderView.frame;
    frame.origin.x = (sender.tag - 100) * itemWidth + (itemWidth - sliderViewWidth)/2;
    
    [UIView animateWithDuration:0.2 animations:^{
        sender.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
        currentItem.transform = CGAffineTransformIdentity;
        _sliderView.frame = frame;
    }];
    !_titleItemClickedCallBackBlock ? : _titleItemClickedCallBackBlock(sender.tag);
}

@end
