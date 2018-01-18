//
//  TabBar.h
//  sinaDemo
//
//  Created by wl on 2018/1/3.
//  Copyright https://github.com/orzzh All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TabBarDelegate<NSObject>

- (void)didSelectedAtIndex:(NSInteger)index;

@end

@interface TabBar : UITabBar

@property (weak) id<TabBarDelegate> wlDelegate;

@end
