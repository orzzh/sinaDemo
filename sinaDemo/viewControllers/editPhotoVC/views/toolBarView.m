//
//  toolBarView.m
//  sinaDemo
//
//  Created by wl on 2018/1/10.
//  Copyright https://github.com/orzzh All rights reserved.
//

#import "toolBarView.h"
#import "SinaButton.h"

@interface toolBarView()
{
    NSMutableArray *_btnAry;
    
}

@end

@implementation toolBarView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)btnAct:(UIButton *)sender{
    for (SinaButton *b in _btnAry) {
        b.selected = NO;
        [b setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];

    }
    sender.selected = YES;
    [sender setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];

    if (self.seletedBlock) {
        self.seletedBlock(sender.tag-10);
    }
}

- (void)createUI{
    self.backgroundColor = [UIColor whiteColor];
    _btnAry = [[NSMutableArray alloc]init];
    NSArray *img = @[@"贴纸",@"滤镜",@"工具"];
    NSArray *imgy = @[@"贴纸-2",@"滤镜-2",@"工具-2"];
    NSArray *titleAry = @[@"贴纸",@"滤镜",@"工具"];

    CGFloat w = self.width/3;
    for (int i =0; i<3; i++) {
        SinaButton *button = [[SinaButton alloc]init];
        button.frame = CGRectMake(i*w, 0, w, 49);
        button.tag = 10+i;
        [button setImage:[UIImage imageNamed:img[i]] forState:UIControlStateNormal];
        [button setTitle:titleAry[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:10];
        [button setImage:[UIImage imageNamed:imgy[i]] forState:UIControlStateSelected];
        if (i == 0) {
            button.selected = YES;
            [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        }
        button.imageView.userInteractionEnabled = YES;
        [button addTarget:self action:@selector(btnAct:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [_btnAry addObject:button];
    }
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    line.backgroundColor = COLOR_GR(0.1);
    [self addSubview:line];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    for (SinaButton *button in _btnAry) {
        CGPoint p = [self convertPoint:point toView:button];
        if ([button pointInside:p withEvent:event]) {
            return button;
        }
    }
    return [super hitTest:point withEvent:event];
}


@end
