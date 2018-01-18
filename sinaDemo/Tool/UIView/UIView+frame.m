//
//  UIView+frame.m
//  sinaDemo
//
//  Created by wl on 2017/9/5.
//  Copyright © 2017年 wl. All rights reserved.
//

#import "UIView+frame.h"

@implementation UIView (frame)

- (CGFloat)originX
{
    return self.frame.origin.x;
}

- (CGFloat)originY
{
    return self.frame.origin.y;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setOriginX:(CGFloat)x
{
    CGRect rect = self.frame;
    rect.origin.x = x;
    self.frame = rect;
}

- (void)setOriginY:(CGFloat)y
{
    CGRect rect = self.frame;
    rect.origin.y = y;
    self.frame = rect;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect rect = self.frame;
    rect.origin = origin;
    self.frame = rect;
}

- (void)setWidth:(CGFloat)width
{
    CGRect rect = self.frame;
    rect.size.width = width;
    self.frame = rect;
}

- (void)setHeight:(CGFloat)height
{
    CGRect rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}

- (void)setSize:(CGSize)size
{
    CGRect rect = self.frame;
    rect.size = size;
    self.frame = rect;
}

- (void)setOriginX:(CGFloat)x originY:(CGFloat)y width:(CGFloat)width height:(CGFloat)height
{
    CGRect rect = self.frame;
    rect.origin.x = x;
    rect.origin.y = y;
    rect.size.width = width;
    rect.size.height = height;
    self.frame = rect;
}


@end
