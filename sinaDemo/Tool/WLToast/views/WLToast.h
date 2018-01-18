//
//  WLToast.h
//  WLToast
//
//  Created by wl on 2017/12/14.
//  Copyright © 2017年 wl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WLToast : UIView

/**
 @param title 内容
 */
+ (void)showToastWithTitle:(NSString *)title;

/**
 @param title 文字内容
 @param colors 背景渐变  颜色1向颜色2渐变
 */
+ (void)showToastWithTitle:(NSString *)title colors:(NSArray *)colors;

/**
 @param title 文字内容
 @param color 背景纯色
 */
+ (void)showToastWithTitle:(NSString *)title color:(UIColor *)color;


/**
 @param image 图
 */
+ (void)setToastImage:(UIImage *)image;


/**
 @param color 字体颜色
 */
+ (void)setToastTitleColor:(UIColor *)color;


/**
 @param offset 位置偏移
 */
+ (void)setToastOffset:(CGFloat)offset;


/**
    默认配置
 */
+ (void)setToastDeful;

+ (void)dismiss;


@end
