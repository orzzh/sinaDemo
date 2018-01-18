//
//  PasteView.m
//  sinaDemo
//
//  Created by wl on 2018/1/10.
//  Copyright https://github.com/orzzh All rights reserved.
//

#import "PasteView.h"

typedef NS_ENUM(NSInteger,MoveType) {
    MoveTypeCenter = 1 ,
    MoveTypeScale,
};
@interface PasteView()
{
    CGPoint starPoint;
    CGPoint movePoint;
    MoveType type; //
    CGPoint myCenter;
}

@property (nonatomic,strong) UILabel *editLbl;
@property (nonatomic,strong) UIButton *cencel;

@end
@implementation PasteView



#pragma mark - Action
- (void)cencelAct{
    if (self.deleteBlock) {
        self.deleteBlock(self.tag);
    }
    [self removeFromSuperview];
}

- (void)tap{
    if (_cencel.hidden) {
        [self showEdit];
    }else{
        [self hideEdit];
    }
}

- (void)showEdit{
    _cencel.hidden = NO;
    _editLbl.hidden = NO;
    self.pasteImage.layer.borderWidth = 2;
}

- (void)hideEdit{
    _cencel.hidden = YES;
    _editLbl.hidden = YES;
    self.pasteImage.layer.borderWidth = 0;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches.allObjects lastObject];
    starPoint = [touch locationInView:self];
    movePoint = [touch locationInView:self];
    
    CGPoint point = [touch locationInView:self];
    CGPoint p = [self convertPoint:point toView:_editLbl];
    if ([_editLbl pointInside:p withEvent:event]) {
        type = MoveTypeScale;
    }else{
        type = MoveTypeCenter;
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches.allObjects lastObject];
    CGPoint point = [touch locationInView:self];
    
    if (type == MoveTypeScale) {
        
/**
    ********************** 需要优化 ************************
 **/
        //大小变化 等比例缩放
        CGFloat x_offset = point.x-movePoint.x;

//        //旋转
//        CGPoint imageCenter = self.pasteImage.center;
////        CGPoint
//        //计算初始弧度
//        CGFloat _x = movePoint.x-imageCenter.x;
//        CGFloat _y = movePoint.y-imageCenter.y;
//        CGFloat _star_Rot = atan2(_x ,_y);
//
//        //计算初始弧度
//        CGFloat _x1 = point.x-imageCenter.x;
//        CGFloat _y1 = point.y-imageCenter.y;
//        CGFloat _end_Rot = atan2(_x1 ,_y1);
//
        //形变
        CGAffineTransform transform = CGAffineTransformScale(self.transform, x_offset/self.width+1, 1+x_offset/self.width);
        self.transform = transform;
//        CGAffineTransformRotate(transform, _star_Rot-_end_Rot);

/**
    ********************** 需要优化 ************************
 **/
    }else{
        
        //位置移动
        CGFloat x_offset = point.x-starPoint.x;
        CGFloat y_offset = point.y-starPoint.y;
        self.center = CGPointMake(self.center.x+x_offset, self.center.y+y_offset);
    }
 
    movePoint = point;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (starPoint.x == movePoint.x && starPoint.y == movePoint.y) { [self tap];}
}





#pragma  mark - lazyload

- (UIImageView *)pasteImage{
    if (!_pasteImage) {
        _pasteImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, self.width-20, self.height-20)];
        _pasteImage.contentMode = UIViewContentModeScaleAspectFit;
        _pasteImage.layer.borderColor = [UIColor whiteColor].CGColor;
        _pasteImage.layer.borderWidth = 2;
        [self addSubview:_pasteImage];
        
        _cencel = [UIButton buttonWithType:UIButtonTypeCustom];
        _cencel.frame = CGRectMake(0, 0, 20, 20);
        _cencel.layer.cornerRadius = 10;
        _cencel.backgroundColor = [UIColor whiteColor];
        [_cencel setTitle:@"X" forState:UIControlStateNormal];
        [_cencel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cencel addTarget:self action:@selector(cencelAct) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cencel];
        
        _editLbl = [[UILabel alloc]init];
        _editLbl.frame = CGRectMake(self.width-20, self.height-20, 20, 20);
        _editLbl.layer.cornerRadius = 10;
        _editLbl.backgroundColor = [UIColor whiteColor];
        _editLbl.textAlignment =1;
        _editLbl.text =@"-";
        [self addSubview:_editLbl];
        
        myCenter = self.center;
        
    }
    return _pasteImage;
}

@end
