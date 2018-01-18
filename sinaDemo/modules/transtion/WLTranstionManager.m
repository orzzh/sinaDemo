//
//  WLTranstionManager.m
//  sinaDemo
//
//  Created by WL on 2018/1/3.
//  Copyright https://github.com/orzzh All rights reserved.
//

#import "WLTranstionManager.h"
#import "WLMenuTranstion.h"
#import "WLPhotoTranstion.h"

@implementation WLTranstionManager

+ (instancetype)managerWithtype:(WLTranstionType)type model:(WLTranstionMode)mode{
    switch (type) {
        case WLTranstionTypeMenu:{
            return [[WLMenuTranstion alloc]initWithModel:mode];
        }break;
        case WLTranstionTypePhoto:{
            return [[WLPhotoTranstion alloc]initWithModel:mode];
        }break;
        default:
            break;
    }
}

- (instancetype)initWithModel:(WLTranstionMode)mode{
    self = [super init];
    if (self) {
        self.transtionMode = mode;
    }
    return self;
}


#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
   //转场时间
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    //转场动画
    switch (self.transtionMode) {
        case WLTranstionModePop:
            [self popTransition:transitionContext];
            break;
        case WLTranstionModePush:
            [self pushTransition:transitionContext];
            break;
        case WLTranstionModePresent:
            [self presentTransition:transitionContext];
            break;
        case WLTranstionModeDismiss:
            [self dismissTransition:transitionContext];
            break;
        default:
            break;
    }
}

#pragma mark - 子类重写

- (void)popTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    NSLog(@"pop重写");
}

- (void)pushTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    NSLog(@"push重写");
}

- (void)presentTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    NSLog(@"present重写");
}

- (void)dismissTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    NSLog(@"dismiss重写");
}

@end
