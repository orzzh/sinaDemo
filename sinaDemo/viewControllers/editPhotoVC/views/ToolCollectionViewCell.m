//
//  ToolCollectionViewCell.m
//  sinaDemo
//
//  Created by wl on 2018/1/10.
//  Copyright https://github.com/orzzh All rights reserved.
//

#import "ToolCollectionViewCell.h"

@implementation ToolCollectionViewCell



- (void)selected{
    self.titleView.textColor = [UIColor whiteColor];
    self.titleView.backgroundColor = [UIColor orangeColor];
}

- (void)deful{
    self.titleView.textColor = [UIColor blackColor];
    self.titleView.backgroundColor = COLOR_GR(0.2);
}

- (UILabel *)titleView{
    if (!_titleView) {
        _titleView = [[UILabel alloc]initWithFrame:CGRectMake(0, self.height*3/4, self.width, self.height/4)];
        _titleView.backgroundColor = COLOR_GR(0.2);
        _titleView.textAlignment = 1;
        _titleView.font = FONTSIZE(12);
        _titleView.textColor = [UIColor blackColor];
        [self addSubview:_titleView];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deful) name:@"deful" object:nil];
    }
    return _titleView;
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView  = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, self.width-20, self.height-20)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        CGFloat r = arc4random()%255;
        CGFloat g = arc4random()%255;
        CGFloat b = arc4random()%255;
        self.backgroundColor = [UIColor colorWithRed:r/255 green:g/255 blue:b/255 alpha:0.4];
        [self addSubview:_imageView];
    }
    return _imageView;
}

- (CALayer *)borderLayer{
    if (!_borderLayer) {
        _borderLayer = [CALayer layer];
        CGFloat ma = 10;
        _borderLayer.frame = CGRectMake(self.imageView.originX-ma, self.imageView.originY-ma, self.imageView.width+ma*2, self.imageView.width+ma*2);
        _borderLayer.cornerRadius = _borderLayer.frame.size.width/2;
        _borderLayer.borderWidth = 1;
        _borderLayer.borderColor = COLOR_GR(0.2).CGColor;
        _borderLayer.hidden = YES;
        [self.layer addSublayer:_borderLayer];
        
        self.backgroundColor = [UIColor clearColor];
    }
    return _borderLayer;
}
@end
