//
//  audioAnimationView.m
//  sinaDemo
//
//  Created by wl on 2018/1/17.
//  Copyright © 2018年 https://github.com/orzzh. All rights reserved.
//

#import "audioAnimationView.h"

#define space 3

@interface audioAnimationView ()

@property (nonatomic,strong)NSMutableArray *layerAry;

@end
@implementation audioAnimationView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _layerAry = [[NSMutableArray alloc]init];
        self.backgroundColor = [UIColor blackColor];
        self.layer.masksToBounds = YES;
        [self addLayer];
        
    }
    return self;
}

- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    
    //判断亮几个
    CGFloat proHeight = _progress *self.height;
    NSInteger index = 0;
    for (NSInteger i = 0 ; i<6; i++) {
        UIView *layer = _layerAry[i];
        UIView *layer1 = (i+1)<6 ? _layerAry[i+1] : nil;
        
        CGFloat h = layer.frame.size.height+space;
        CGFloat layer_h = layer.frame.origin.y+ h;
        CGFloat layer1_h = layer1.frame.origin.y+ h;
        
        if (layer_h>= proHeight) {
            index = i;
            break;
        }
        if (proHeight >=layer_h && proHeight <= layer1_h) {
            index = i+1;
            break;
        }
    }
    
    for (int i =0; i<_layerAry.count; i++) {
        UIView *layer = _layerAry[5-i];
        layer.hidden = i<index ?NO:YES;
        layer.alpha = 1;
    }
    
    //透明度百分百
    UIView *layer = index>0 ? _layerAry[index-1] : _layerAry[index];
    CGFloat beyound = proHeight - layer.frame.origin.y-layer.frame.size.height-space;
    CGFloat alph = beyound/layer.frame.size.height;

    UIView *curLayer = _layerAry[5-index];
    curLayer.hidden = NO;
    curLayer.alpha = alph;
    
}

- (void)addLayer{
    CGFloat height =(self.height-space*5)/6;
    CGFloat diff   = (self.width*2/3)/6;
    
    for (int i =0; i<6;i++) {
        UIView *layer = [[UIView alloc]init];
        layer.frame = CGRectMake(0, i*(space+height), self.width - i*diff, height);
        layer.backgroundColor = [UIColor whiteColor];
        layer.layer.cornerRadius = height/4;
        [self addSubview:layer];
        [_layerAry addObject:layer];
    }
}

@end
