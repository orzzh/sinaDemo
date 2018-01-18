//
//  YearPickView.h
//  sinaDemo
//
//  Created by wl on 2018/1/9.
//  Copyright https://github.com/orzzh All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YearPickView : UIView

@property (copy)void(^selectBlock)(NSString *year);

- (void)show;

- (void)setMaxYear:(NSString *)maxyear minYear:(NSString *)minyear;

@end
