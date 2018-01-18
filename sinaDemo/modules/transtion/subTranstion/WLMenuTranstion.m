//
//  wlMenuTranstion.m
//  sinaDemo
//
//  Created by wl on 2018/1/3.
//  Copyright https://github.com/orzzh All rights reserved.
//

#import "WLMenuTranstion.h"
#import "WLMenuView.h"
#import "MenuViewController.h"
#import "WLPhotoViewController.h"

@implementation WLMenuTranstion

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    //转场时间
    return 0.3;
}

- (void)presentTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
     UIViewController *formVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

   UINavigationController *nv = (UINavigationController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    nv.view.backgroundColor = [UIColor clearColor];
    __block MenuViewController *toVC = (MenuViewController*)[nv.viewControllers firstObject];
    
    //隐藏目的视图 view
    toVC.menuView.hidden = YES;
    
    //转场view
    UIView *contentView = [transitionContext containerView];
    UIView *fromView = nil;
    UIView *toView = nil;
    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    }else{
        fromView = formVC.view;
        toView = toVC.view;
    }
    
    // 目的视图view添加
    [contentView addSubview:toView];

    CGRect rect = CGRectMake(0, SCREENH_HEIGHT-SCREEN_WIDTH/2-49-50-IPX, SCREEN_WIDTH, SCREEN_WIDTH/2);
    NSArray *titleAry = @[@"文字",@"拍摄",@"相册",@"直播",@"光影秀",@"提问",@"签到",@"点评"];
    NSArray *imageAry = @[];
    
    //动画view
     __block WLMenuView *menuView = [[WLMenuView alloc]initWithFrame:rect titleAry:titleAry imageAry:imageAry];
    [contentView addSubview:menuView];
    [menuView anmationStar:YES];
    
    menuView.completeBlock = ^{
        menuView.hidden = YES;
        toVC.menuView.hidden = NO;
    };
    
    [transitionContext completeTransition: !transitionContext.transitionWasCancelled];
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        toVC.view.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.8];
        toVC.cencel.transform = CGAffineTransformMakeRotation(M_PI_4);
    }];
}


- (void)dismissTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    UINavigationController *nv = (UINavigationController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    __block MenuViewController *fromVC = (MenuViewController*)[nv.viewControllers firstObject];
    fromVC.menuView.hidden = YES;

    UIView *contentView = [transitionContext containerView];
    UIView *menuView = [contentView.subviews lastObject];
    
    //转场view取消隐藏
    menuView.hidden = NO;
    
    if ([menuView isKindOfClass:[WLMenuView class]]) {
        WLMenuView *menu = (WLMenuView *)menuView;
        menu.completeBlock = ^{
            [UIView animateWithDuration:0.3 animations:^{
                fromVC.view.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0];
            }];
        };
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fromVC.cencel.transform = CGAffineTransformRotate(fromVC.cencel.transform, -M_PI_4);
        } completion:^(BOOL finished) {
            [transitionContext completeTransition: !transitionContext.transitionWasCancelled];
        }];
        
        //动画开始
        [menu anmationStar:NO];
    }
}



@end
