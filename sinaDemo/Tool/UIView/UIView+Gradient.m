//
//  UIView+Gradient.m
//  sinaDemo
//
//  Created by wl on 2018/1/15.
//  Copyright © 2018年 https://github.com/orzzh. All rights reserved.
//

#import "UIView+Gradient.h"

@implementation UIView (Gradient)


-(void)setGradientBgColorWithColors:(NSArray *)colors locations:(NSArray *)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    if (colors == nil || [colors isKindOfClass:[NSNull class]] || colors.count == 0){
        return;
    }
    if (locations == nil || [locations isKindOfClass:[NSNull class]] || locations.count == 0){
        return;
    }
    NSMutableArray *colorsTemp = [NSMutableArray new];
    for (UIColor *color in colors) {
        if ([color isKindOfClass:[UIColor class]]) {
            [colorsTemp addObject:(__bridge id)color.CGColor];
        }
    }
    gradientLayer.colors = colorsTemp;
    gradientLayer.locations = locations;
    gradientLayer.startPoint = startPoint;
    gradientLayer.endPoint = endPoint;
    gradientLayer.frame =  self.bounds;
    [self.layer insertSublayer:gradientLayer atIndex:0];
}
-(CAGradientLayer *)getGradientBgColorWithColors:(NSArray *)colors locations:(NSArray *)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    if (colors == nil || [colors isKindOfClass:[NSNull class]] || colors.count == 0){
        return nil;
    }
    if (locations == nil || [locations isKindOfClass:[NSNull class]] || locations.count == 0){
        return nil;
    }
    NSMutableArray *colorsTemp = [NSMutableArray new];
    for (UIColor *color in colors) {
        if ([color isKindOfClass:[UIColor class]]) {
            [colorsTemp addObject:(__bridge id)color.CGColor];
        }
    }
    gradientLayer.colors = colorsTemp;
    gradientLayer.locations = locations;
    gradientLayer.startPoint = startPoint;
    gradientLayer.endPoint = endPoint;
    gradientLayer.frame =  self.bounds;
    return gradientLayer;
}

-(void)setBorderAndCornerWithRadius:(CGFloat)redius borderWidth:(CGFloat)width borderColor:(UIColor *)color{
    [self.layer setCornerRadius:redius];
    [self.layer setMasksToBounds:YES];
    [self.layer setBorderWidth:width];
    [self.layer setBorderColor:[color CGColor]];
}

- (void)setBorderWithTop:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width
{
    if (top) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, self.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [self.layer addSublayer:layer];
    }
    if (left) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, width, self.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [self.layer addSublayer:layer];
    }
    if (bottom) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, self.frame.size.height - width, self.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [self.layer addSublayer:layer];
    }
    if (right) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(self.frame.size.width - width, 0, width, self.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [self.layer addSublayer:layer];
    }
}



- (void)addLine{
    CALayer *laye = [CALayer layer];
    laye.frame = CGRectMake(0, IPX_NV, SCREEN_WIDTH, SCREEN_WIDTH);
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(self.frame.size.width/3, 0, 1, self.frame.size.width);
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    [laye addSublayer:layer];
    
    CALayer *layer1 = [CALayer layer];
    layer1.frame = CGRectMake(self.frame.size.width*2/3, 0, 1, self.frame.size.width);
    layer1.backgroundColor = [UIColor whiteColor].CGColor;
    [laye addSublayer:layer1];
    
    CALayer *layer11 = [CALayer layer];
    layer11.frame = CGRectMake(0, self.frame.size.width/3, self.frame.size.width, 1);
    layer11.backgroundColor = [UIColor whiteColor].CGColor;
    [laye addSublayer:layer11];
    
    CALayer *layer111 = [CALayer layer];
    layer111.frame = CGRectMake(0, self.frame.size.width*2/3, self.frame.size.width, 1);
    layer111.backgroundColor = [UIColor whiteColor].CGColor;
    [laye addSublayer:layer111];
    
    [self.layer addSublayer:laye];
}
@end
