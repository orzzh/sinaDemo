//
//  wlMenuView.h
//  sinaDemo
//
//  Created by wl on 2018/1/3.
//  Copyright https://github.com/orzzh All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WLMenuView : UIView


/**
 动画完成block
 */
@property (copy) void(^completeBlock)(void);


/**
 选择ietm block
 */
@property (copy) void(^block)(NSInteger);


/**
 初始化

 @param frame frame
 @param titleAry 文字数组
 @param imageAry 背景数组
 @return self
 */
- (instancetype)initWithFrame:(CGRect)frame titleAry:(NSArray *)titleAry imageAry:(NSArray *)imageAry;


/**
 动画开始

 @param eable yes／no
 */
- (void)anmationStar:(BOOL)eable;


@end
