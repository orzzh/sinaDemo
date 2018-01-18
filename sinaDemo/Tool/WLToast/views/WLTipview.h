//
//  WLTipview.h
//  WLToast
//
//  Created by wl on 2017/12/14.
//  Copyright © 2017年 wl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WLTipview : UIView

/**
 @param title 文字内容
 */
+ (void)showTipWithTitle:(NSString *)title;


/**
 @param title 文字内容
 @param starY 起始位置
 */
+ (void)showTipWithTitle:(NSString *)title starY:(CGFloat)starY;

+ (void)dismiss;


@end
