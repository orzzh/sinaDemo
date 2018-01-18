
//
//  ToastManage.m
//  WLToast
//
//  Created by wl on 2017/12/14.
//  Copyright © 2017年 wl. All rights reserved.
//

#import "ToastManage.h"
#import "WLToast.h"
#import "WLTipview.h"

@implementation ToastManage

#pragma mark - top

+ (void)showTopToastWith:(NSString *)title leftImg:(UIImage *)img titleColor:(UIColor *)color{
    [WLToast setToastImage:img];
    [WLToast setToastTitleColor:color];
    [WLToast setToastOffset:0];
    [WLToast showToastWithTitle:title];
}

+ (void)showTopToastWith:(NSString *)title{
    [WLToast setToastDeful];
    [WLToast showToastWithTitle:title];
}

+ (void)showTopToastWith:(NSString *)title colors:(NSArray *)colors{
    [WLToast setToastDeful];
    [WLToast showToastWithTitle:title colors:colors];
}

+ (void)showTopToastWith:(NSString *)title color:(UIColor *)color{
    [WLToast setToastDeful];
    [WLToast showToastWithTitle:title color:color];
}

+ (void)showTopToastWith:(NSString *)title colors:(NSArray *)colors leftImg:(UIImage *)img titleColor:(UIColor *)color offset:(CGFloat)offset{
    [WLToast setToastOffset:offset];
    [WLToast setToastImage:img];
    [WLToast setToastTitleColor:color];
    [WLToast showToastWithTitle:title colors:colors];
}


#pragma mark - center
+ (void)showCenterToastWith:(NSString *)title{
    [WLTipview showTipWithTitle:title];
}
+ (void)showCenterToastWith:(NSString *)title starY:(CGFloat)starY{
    [WLTipview showTipWithTitle:title starY:starY];
}

#pragma mark - bottom

+ (void)showBottomToastWith:(NSString *)title{

}


+ (void)dismiss{
    [WLToast dismiss];
    [WLTipview dismiss];
}


@end
