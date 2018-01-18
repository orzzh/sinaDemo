//
//  UIView+Gradient.h
//  sinaDemo
//
//  Created by wl on 2018/1/15.
//  Copyright © 2018年 https://github.com/orzzh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Gradient)


/**
 生成渐变背景色
 
 @param colors 渐变的颜色
 @param locations 渐变颜色的分割点
 @param startPoint 渐变颜色的方向起点，范围在（0，0）与（1.0，1.0）之间，如(0,0)(1.0,0)代表水平方向渐变,(0,0)(0,1.0)代表竖直方向渐变
 @param endPoint  渐变颜色的方向终点
 */
-(void)setGradientBgColorWithColors:(NSArray *)colors locations:(NSArray *)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;



/**
 设置圆角和边框
 
 @param redius 圆角大小
 @param width 边框宽度
 @param color 边框颜色
 */
-(void)setBorderAndCornerWithRadius:(CGFloat)redius borderWidth:(CGFloat)width borderColor:(UIColor *)color;




/**
 边框
 
 @param top 顶部
 @param left 左侧
 @param bottom 底部
 @param right 右侧
 @param color 边框颜色
 @param width 边框宽度
 */
- (void)setBorderWithTop:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width;


/**
 返回渐变layer
 
 @param colors 渐变的颜色
 @param locations 渐变颜色的分割点
 @param startPoint 渐变颜色的方向起点，范围在（0，0）与（1.0，1.0）之间，如(0,0)(1.0,0)代表水平方向渐变,(0,0)(0,1.0)代表竖直方向渐变
 @param endPoint  渐变颜色的方向终点
 */
-(CAGradientLayer *)getGradientBgColorWithColors:(NSArray *)colors locations:(NSArray *)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

- (void)addLine;

@end
