//
//  TabBar.m
//  sinaDemo
//
//  Created by wl on 2018/1/3.
//  Copyright https://github.com/orzzh All rights reserved.
//

#import "TabBar.h"
#import "SinaButton.h"
@interface TabBar()

@property (nonatomic,strong)NSMutableArray *barAry;

@end

@implementation TabBar

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self stepViews];
    }
    return self;
}

- (void)stepViews{
    _barAry = [[NSMutableArray alloc]init];
    NSArray *img = @[@"首页n",@"信息n",@"首页n",@"发现n",@"我n"];
    NSArray *imgy = @[@"首页y",@"信息y",@"首页y",@"发现y",@"我y"];
    NSArray *titleAry = @[@"首页",@"消息",@"首页y",@"发现",@"我"];

    CGFloat w = self.width/5;
    for (int i = 0; i<5; i++) {
        UIButton *button = [[UIButton alloc]init];
        if (i==2) {
            button.frame = CGRectMake(0, 0, 50, 44);
            button.center = CGPointMake(self.center.x, 49/2);
            button.tag = 10+i;
            button.backgroundColor = [UIColor orangeColor];
            [button setImage:[UIImage imageNamed:@"+"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            button.layer.cornerRadius = 5;
            button.layer.masksToBounds = YES;
        }else{
            button = [[SinaButton alloc]init];
            button.frame = CGRectMake(i*w, 0, w, 49);
            button.tag = 10+i;
            [button setImage:[UIImage imageNamed:img[i]] forState:UIControlStateNormal];
            [button setTitle:titleAry[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:10];
            [button setImage:[UIImage imageNamed:imgy[i]] forState:UIControlStateSelected];
        }
        if (i == 0) {
            button.selected = YES;
        }
        button.imageView.userInteractionEnabled = YES;
        [button addTarget:self action:@selector(btnAct:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [_barAry addObject:button];
        
    }
}
- (void)btnAct:(UIButton *)sender{
    [self.wlDelegate didSelectedAtIndex:sender.tag-10];
    
    //点击中间 状态不改变
    if (sender.tag-10 == 2) {return;}
    
    for (UIButton *btn in _barAry) {
        btn.selected = NO;
    }
    sender.selected = YES;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    for (UIButton *btn in _barAry) {
        CGPoint p = [self convertPoint:point toView:btn];
        if ([btn pointInside:p withEvent:event]) {
            return btn;
        }
    }
    return nil;
}

@end
