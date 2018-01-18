
//
//  wlMenuView.m
//  sinaDemo
//
//  Created by wl on 2018/1/3.
//  Copyright https://github.com/orzzh All rights reserved.
//

#import "WLMenuView.h"

#define BOTTOM 400
#define BOTTOM_STAR 100

@interface WLMenuView()
{
    CGPoint point;
    NSMutableArray *btnAry;
}
@end
@implementation WLMenuView


- (instancetype)initWithFrame:(CGRect)frame titleAry:(NSArray *)titleAry imageAry:(NSArray *)imageAry{
    
    if (self == [super initWithFrame:frame]) {
        
        CGFloat wigth = 60;
        CGFloat pace = SCREEN_WIDTH/4-73;
        CGFloat left_x = (SCREEN_WIDTH - wigth*4 - pace*3)/2;
        
        for (int i =0; i<2; i++) {
            for (int j = 0; j<4; j++) {
                UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, wigth, wigth)];
                btn.layer.cornerRadius = wigth/2;
                btn.backgroundColor =[UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:0.7];
                btn.tag = i*4+j+10;
                btn.titleLabel.font = [UIFont boldSystemFontOfSize:24];
//                [btn setImage:[UIImage imageNamed:imageAry[i+j]] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(selectedAct:) forControlEvents:UIControlEventTouchUpInside];

                UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, wigth, wigth, 30)];
                lbl.textAlignment = 1;
                lbl.textColor = [UIColor grayColor];
                lbl.text = titleAry[i+j];
                lbl.font = [UIFont fontWithName:FONT size:12];
                
                UIView *stack = [[UIView alloc]init];
                stack.frame = CGRectMake(j*wigth +pace *j +left_x, (wigth+40)*i, wigth, wigth+30);
                [self addSubview:stack];
                [btnAry addObject:stack];
                stack.tag = i*4+j;
                [stack addSubview:btn];
                [stack addSubview:lbl];
            }
        }
    }
    return self;
}

- (void)selectedAct:(UIButton *)sender{
    UIView *view = sender.superview;
    NSInteger tag = view.tag;
    
    //缩小动画
    for (UIView *v in self.subviews) {
        if (v.tag != tag) {
            [UIView animateWithDuration:0.3 animations:^{
                v.alpha = 0;
                v.transform = CGAffineTransformMakeScale(0.5, 0.5);
            }];
        }
    }
    
    //点击放大
    [UIView animateWithDuration:0.3 animations:^{
        view.alpha = 0.1;
        view.transform = CGAffineTransformMakeScale(1.5, 1.5);
    } completion:^(BOOL finished) {
        self.block(sender.tag-10);
    }];
    
}


- (void)anmationStar:(BOOL)eable{
    if (eable) {
        
        //动画开始
        
        for (UIView *view in self.subviews) {
            UIView *btn = (UIView*)view;
            
            CGFloat delay = btn.tag;
            
            btn.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y+BOTTOM_STAR, view.frame.size.width, view.frame.size.height);
            btn.alpha = 0;

            [UIView animateWithDuration:0.5 delay:0.0f+delay*0.02 usingSpringWithDamping:0.6f initialSpringVelocity:1.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                btn.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y-BOTTOM_STAR, view.frame.size.width, view.frame.size.height);
                btn.alpha = 1;
                
            } completion:^(BOOL finished) {
                if (self.completeBlock) {
                    self.completeBlock();
                }
            }];
        }
        
    }else{
        
        //动画结束
        
        for (UIView *view in self.subviews) {
            UIButton *btn = (UIButton *)view;
            
            CGFloat delay = btn.tag;
            CGFloat time= 0.14f-delay*0.025f;
            
            [UIView animateWithDuration:1 delay:time usingSpringWithDamping:0.6f initialSpringVelocity:0.4f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                btn.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y+BOTTOM, view.frame.size.width, view.frame.size.height);
                btn.alpha = 0.2;
                
            } completion:^(BOOL finished) {
                if (self.completeBlock) {
                    self.completeBlock();
                }
            }];
        }
        
//        [self performSelector:@selector(outAct) withObject:nil afterDelay:0.5];
    }
}

- (void)outAct{
    NSLog(@"你选择了99");
    self.block(99);
}


@end
