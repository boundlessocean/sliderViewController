//
//  BLSliderView.m
//  BLSinaNewsSliderViewControllerDemo
//
//  Created by boundlessocean on 2016/12/23.
//  Copyright © 2016年 ocean. All rights reserved.
//

#import "BLSliderView.h"

@implementation BLSliderView

// 滑动进度
- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (_progress > 0 && _progress <= 1) {
        CGRect frame = self.frame;        frame.size.width = _sliderWidth + _itemWidth * (_progress > 0.5 ? 1 - _progress : _progress);
        frame.origin.x = frame.origin.x + _itemWidth * _progress;
        self.frame = frame;
    }
}
@end
