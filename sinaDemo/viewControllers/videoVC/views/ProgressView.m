//
//  ProgressView.m
//  sinaDemo
//
//  Created by wl on 2018/1/17.
//  Copyright © 2018年 https://github.com/orzzh. All rights reserved.
//

#import "ProgressView.h"
@interface ProgressView ()
{
    NSInteger _index;
    CALayer *delLayer;
}
@property (nonatomic,strong)NSMutableArray *blockAry;
@property (nonatomic,strong)NSMutableArray *layerAry;
@property (nonatomic,strong)CALayer *currLayer;
@property (nonatomic,strong)CALayer *block;
@property (nonatomic,strong)CALayer *stantard;

@end
@implementation ProgressView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _index = 99;
        _layerAry = [[NSMutableArray alloc]init];
        _blockAry = [[NSMutableArray alloc]init];
        
        [self.layer addSublayer:self.stantard];
        [self.layer addSublayer:self.currLayer];
        [self.layer addSublayer:self.block];
    }
    return self;
}

- (void)setSecond:(CGFloat)second index:(NSInteger)index{
    if (delLayer) {
        [delLayer removeFromSuperlayer];
        delLayer = nil;
    }
    if ( _index != index) {
    
        CGFloat wid = _currLayer.frame.size.width;
        [_layerAry addObject:[NSString stringWithFormat:@"%f",wid]];

        if (_index != 99) { //添加白块
            CGFloat sum = [[_layerAry lastObject]integerValue];
            CALayer *la = [CALayer layer];
            la.frame = CGRectMake(sum, 0, 1, self.height);
            la.backgroundColor = [UIColor whiteColor].CGColor;
            [_blockAry addObject:la];
            [_currLayer addSublayer:la];
        }
        _index = index;
    }
    CGFloat w = second/self.maxSecond;
    _currLayer.frame = CGRectMake(0, 0, w*self.width, self.height);
    self.block.frame = CGRectMake(_currLayer.frame.origin.x+_currLayer.frame.size.width, 0, self.height, self.height);
}

- (void)showLast{
    CGFloat w = [[_layerAry lastObject] integerValue];
    CGFloat curr_wid = _currLayer.frame.size.width;
    
    delLayer = [CALayer layer];
    delLayer.backgroundColor =[UIColor redColor].CGColor;
    if (_layerAry.count == 1) {
        NSLog(@"1");
        delLayer.frame = CGRectMake(0, 0, curr_wid, self.height);
    }else{
        delLayer.frame = CGRectMake(w, 0, curr_wid-w, self.height);
    }
    [_currLayer addSublayer:delLayer];
}

- (void)deleteLast{
    [delLayer removeFromSuperlayer];
    delLayer = nil;
    CGFloat w = [[_layerAry lastObject] integerValue];
    _currLayer.frame = CGRectMake(0, 0, w, self.height);
    self.block.frame = CGRectMake(_currLayer.frame.origin.x+_currLayer.frame.size.width, 0, self.height, self.height);
    [_layerAry removeLastObject];
    
    CALayer *layer=[_blockAry lastObject];
    [layer removeFromSuperlayer];
    [_blockAry removeLastObject];
    
    if (_layerAry.count == 0) {
        _index = 99;
    }
}

- (BOOL)checkProgress{
    BOOL pass = self.stantard.frame.origin.x+1<=self.currLayer.frame.size.width ? YES : NO;
    return pass;
}


#pragma  mark - lazyload

- (CALayer *)currLayer{
    if (!_currLayer) {
        _currLayer = [CALayer layer];
        _currLayer.frame = CGRectMake(0, 0, 0, self.height);
        _currLayer.backgroundColor = [UIColor orangeColor].CGColor;
    }
    return _currLayer;
}
- (CGFloat)maxSecond{
    if (!_maxSecond) {
        _maxSecond = 12;
    }
    return _maxSecond;
}
- (CALayer *)block{
    if (!_block) {
        _block = [CALayer layer];
        _block.frame = CGRectMake(0, 0, self.height, self.height);
        _block.backgroundColor = [UIColor blackColor].CGColor;
        
        CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"opacity"];
        anima.fromValue = @(0);
        anima.toValue = @(1);
        anima.repeatCount = MAXFLOAT;
        anima.duration = 0.5;
        [_block addAnimation:anima forKey:@"ani"];
    }
    return _block;
}
- (CALayer *)stantard{
    if (!_stantard) {
        _stantard = [CALayer layer];
        _stantard.frame = CGRectMake(self.width*3/self.maxSecond-1, 0, 1, self.height);
        _stantard.backgroundColor = [UIColor whiteColor].CGColor;
        CALayer *black = [CALayer layer];
        black.frame = CGRectMake(self.width*3/self.maxSecond, 0, 2, self.height);
        black.backgroundColor = [UIColor blackColor].CGColor;
        [self.layer addSublayer:black];
    }
    return _stantard;
}

@end
