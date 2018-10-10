//
//  BLTitleItem.m
//  BLSinaNewsSliderViewControllerDemo
//
//  Created by boundlessocean on 2016/12/23.
//  Copyright © 2016年 ocean. All rights reserved.
//

#import "BLTitleItem.h"

@implementation BLTitleItem

// 滑动进度
- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (_progress > 0 && _progress <= 1) {
        [self setTitleColor:[UIColor colorWithRed:0 + 1*_progress green:0 blue:0 alpha:1] forState:UIControlStateNormal];
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1 + 0.1 * _progress, 1 + 0.1 * _progress);
    }
}
@end
