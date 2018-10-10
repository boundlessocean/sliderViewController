//
//  BLSliderViewController.h
//  BLSinaNewsSliderViewControllerDemo
//
//  Created by boundlessocean on 2016/12/23.
//  Copyright © 2016年 ocean. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BLSliderViewController;
@protocol BLSliderViewControllerDataSource <NSObject>
/** 标题个数 */
- (NSArray<NSString *> *)bl_titlesArrayInSliderViewController;
/** index对应的子控制器 */
- (UIViewController *)bl_sliderViewController:(BLSliderViewController *)sliderVC subViewControllerAtIndxe:(NSInteger)index;
@optional
/** 子视图高度 (不包含optionalView高度的子视图高度, optionalView高度40), 默认适配全屏*/
- (CGFloat)bl_viewOfChildViewControllerHeightInSliderViewController;
/** 子视图起始位置（y），默认在状态栏之下 */
- (CGFloat)bl_optionalViewStartYInSliderViewController;
@end

@interface BLSliderViewController : UIViewController

@property (nonatomic, weak) id<BLSliderViewControllerDataSource> dataSource;
@end
