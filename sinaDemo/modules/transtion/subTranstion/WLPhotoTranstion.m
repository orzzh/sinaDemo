//
//  wlPhotoTranstion.m
//  sinaDemo
//
//  Created by wl on 2018/1/5.
//  Copyright https://github.com/orzzh All rights reserved.
//

#import "WLPhotoTranstion.h"
#import "WLBrowseViewController.h"
#import "WLPhotoViewController.h"
#import "WLPhotoCollectionViewCell.h"
#import "PhotoAssetModel.h"
#import "WLPohotoManager.h"
#import "WLBrowseViewCell.h"

@implementation WLPhotoTranstion


- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.3;
}

- (void)popTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    WLBrowseViewController *fromVC = (WLBrowseViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    WLPhotoViewController *toVC = (WLPhotoViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    UIView *toView = nil;
    UIView *contView = [transitionContext containerView];
    UIView *fromV = [contView.subviews lastObject];
    
    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
        toView   = [transitionContext viewForKey:UITransitionContextToViewKey];
    }else{
        toView   = toVC.view;
    }
    
    WLBrowseViewCell *broCell = (WLBrowseViewCell*)[fromVC.wlScrView cellForItemAtCurrtueIndex];
    NSIndexPath *path = [NSIndexPath indexPathForRow:broCell.index_row inSection:0];
    WLPhotoCollectionViewCell *cell = (WLPhotoCollectionViewCell*)[toVC.colloectView cellForItemAtIndexPath:path];
    
    UIView *tempView = [broCell.imageView snapshotViewAfterScreenUpdates:YES];
    tempView.contentMode = UIViewContentModeScaleAspectFill;
    tempView.layer.masksToBounds = YES;
    tempView.frame = CGRectMake(broCell.imageRect.origin.x, broCell.imageRect.origin.y+IPX_NV, broCell.imageRect.size.width, broCell.imageRect.size.height);
    
    [contView insertSubview:toView atIndex:0];
    [contView addSubview:tempView];
    cell.hidden = YES;
    
    //弹簧效果
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
        tempView.frame = [cell convertRect:cell.bounds toView:contView];
        fromV.alpha = 0;
    } completion:^(BOOL finished) {
        cell.hidden = NO;
        [tempView removeFromSuperview];
        [fromV removeFromSuperview];
        [transitionContext completeTransition:!transitionContext.interactive];
    }];
}

- (void)pushTransition:(id<UIViewControllerContextTransitioning>)transitionContext{

    WLPhotoViewController *fromVC = (WLPhotoViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    WLBrowseViewController *toVC = (WLBrowseViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *toView = nil;
    UIView *fromView =nil;
    UIView *contView = [transitionContext containerView];
    
    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
        toView   = [transitionContext viewForKey:UITransitionContextToViewKey];
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    }else{
        toView   = toVC.view;
        fromView = fromVC.view;
    }
    
    //取出点击 cell
    WLPhotoCollectionViewCell *cell = (WLPhotoCollectionViewCell*)[fromVC.colloectView cellForItemAtIndexPath:fromVC.selectIndex];
    WLBrowseViewCell *broCell = (WLBrowseViewCell*)[toVC.wlScrView cellForItemAtCurrtueIndex];
    
    //** 这里用的赋值。不知道为什么 snp截图会 延迟一下 产生闪烁
    UIImageView *tempView = [[UIImageView alloc]initWithImage:broCell.imageView.image];
    tempView.contentMode = UIViewContentModeScaleAspectFill;
    tempView.layer.masksToBounds = YES;
    tempView.frame = [cell convertRect:cell.bounds toView:contView];
    
    //白渐变背景
    UIView *white = [[UIView alloc]initWithFrame:contView.bounds];
    white.backgroundColor = [UIColor whiteColor];
    white.alpha = 0;
    
    [contView addSubview:fromView];
    [contView addSubview:toView];
    [contView addSubview:white];
    [contView addSubview:tempView];
    
    //隐藏选中cell 和 最终页面 image
    toView.hidden = YES;
    cell.hidden = YES;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        tempView.frame = CGRectMake(broCell.imageRect.origin.x, broCell.imageRect.origin.y+IPX_NV, broCell.imageRect.size.width, broCell.imageRect.size.height);
        white.alpha = 1;
    }completion:^(BOOL finished) {
        tempView.hidden = YES;
        toView.hidden = NO;
        cell.hidden = NO;
        [white removeFromSuperview];
        [tempView removeFromSuperview];
        [transitionContext completeTransition:!transitionContext.interactive];
    }];
}


@end
