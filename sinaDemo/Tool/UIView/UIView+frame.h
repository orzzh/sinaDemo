//
//  UIView+frame.h
//  sinaDemo
//
//  Created by wl on 2017/9/5.
//  Copyright © 2017年 wl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (frame)

- (CGFloat)originX;
- (CGFloat)originY;
- (CGPoint)origin;
- (CGFloat)width;
- (CGFloat)height;
- (CGSize)size;

- (void)setOriginX:(CGFloat)x;
- (void)setOriginY:(CGFloat)y;
- (void)setOrigin:(CGPoint)origin;
- (void)setWidth:(CGFloat)width;
- (void)setHeight:(CGFloat)height;
- (void)setSize:(CGSize)size;
@end

