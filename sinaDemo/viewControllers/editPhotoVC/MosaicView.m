//
//  MosaicView.m
//  sinaDemo
//
//  Created by wl on 2018/1/12.
//  Copyright https://github.com/orzzh All rights reserved.
//

#import "MosaicView.h"

@interface MosaicView()
{
//    CAShapeLayer *shapeLayer;
}
@property (nonatomic, strong) UIImageView *surfaceImageView;

@property (nonatomic, strong) CALayer *imageLayer;

@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@property (nonatomic, strong) CALayer *maskLayer;

//设置手指的涂抹路径
@property (nonatomic, assign) CGMutablePathRef path;

@end

@implementation MosaicView


- (void)dealloc
{
    if (self.path) {
        CGPathRelease(self.path);
    }
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //添加imageview（surfaceImageView）到self上
        self.surfaceImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        [self addSubview:self.surfaceImageView];
        
        _isOpen = NO;
        _lineWidth = 20.f;
        //添加layer（imageLayer）到self上
        self.imageLayer = [CALayer layer];
        self.imageLayer.frame = self.bounds;
        [self.layer addSublayer:self.imageLayer];
        
        self.shapeLayer = [CAShapeLayer layer];
        self.shapeLayer.frame = self.bounds;
        self.shapeLayer.lineCap = kCALineCapRound;
        self.shapeLayer.lineJoin = kCALineJoinRound;
        self.shapeLayer.lineWidth = _lineWidth;
        self.shapeLayer.strokeColor = [UIColor blueColor].CGColor;
        self.shapeLayer.fillColor = nil;//此处设置颜色有异常效果，可以自己试试
        
        [self.layer addSublayer:self.shapeLayer];
        self.imageLayer.mask = self.shapeLayer;
        
        self.path = CGPathCreateMutable();
    }
    return self;
}

- (void)setLineWidth:(CGFloat)lineWidth{
    _lineWidth = lineWidth;
    self.shapeLayer.lineWidth = _lineWidth;
}

- (void)removePath{
    self.shapeLayer.path = nil;
    self.path = CGPathCreateMutable();
}

- (void)setImage:(UIImage *)image
{
    //处理图
    _image = image;
    self.imageLayer.contents = (id)image.CGImage;
}

- (void)setSurfaceImage:(UIImage *)surfaceImage
{
    //原图
    _surfaceImage = surfaceImage;
    self.surfaceImageView.image = surfaceImage;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if (!_isOpen) {return;}
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGPathMoveToPoint(self.path, NULL, point.x, point.y);
    CGMutablePathRef path = CGPathCreateMutableCopy(self.path);
    self.shapeLayer.path = path;
    CGPathRelease(path);
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    if (!_isOpen) {return;}
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGPathAddLineToPoint(self.path, NULL, point.x, point.y);
    CGMutablePathRef path = CGPathCreateMutableCopy(self.path);
    self.shapeLayer.path = path;
    CGPathRelease(path);
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
}



@end
