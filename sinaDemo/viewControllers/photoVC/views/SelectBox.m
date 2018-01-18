//
//  SelectBox.m
//  sinaDemo
//
//  Created by wl on 2018/1/4.
//  Copyright https://github.com/orzzh All rights reserved.
//

#import "SelectBox.h"
@interface SelectBox()
{
    UIColor *_selectColor;
    UIColor *_defulColor;
}


@end
@implementation SelectBox

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.cornerRadius = frame.size.width/2;
        [self setBackgroundImage:[UIImage imageNamed:@"选中"] forState:UIControlStateSelected];
        _selectColor = [UIColor whiteColor];
        _defulColor = [UIColor clearColor];
        self.selected = NO;
    }
    return self;
}

- (void)setSelectBackboundColor:(UIColor *)selectColor dedul:(UIColor *)color{
    _selectColor = selectColor;
    _defulColor = color;
}


#pragma  mark - 选中效果切换

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
        self.backgroundColor = _selectColor;
        self.layer.borderWidth = 0;

        [UIView animateWithDuration:0.1 animations:^{
            self.transform = CGAffineTransformMakeScale(1.2, 1.2);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.7 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.transform =  CGAffineTransformIdentity;
            } completion:nil];
        }];
        
    }else{
        self.backgroundColor = _defulColor;
        self.layer.borderWidth = 1;
    }
}

@end
