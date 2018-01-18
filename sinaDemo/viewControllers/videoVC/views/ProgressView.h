//
//  ProgressView.h
//  sinaDemo
//
//  Created by wl on 2018/1/17.
//  Copyright © 2018年 https://github.com/orzzh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressView : UIView

@property (nonatomic,assign)CGFloat maxSecond;


/**
  设置进度

 @param second 秒数
 @param index  视频段index
 */
- (void)setSecond:(CGFloat)second index:(NSInteger)index;


/**
  标红最后一段
 */
- (void)showLast;


/**
  删除最后一段
 */
- (void)deleteLast;


/**
 是否达到最低时间
 */
- (BOOL)checkProgress;

@end
