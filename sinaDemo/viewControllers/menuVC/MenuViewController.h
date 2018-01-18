//
//  MenuViewController.h
//  sinaDemo
//
//  Created by wl on 2018/1/3.
//  Copyright https://github.com/orzzh All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WLMenuView.h"

@interface MenuViewController : UIViewController

@property (nonatomic,strong)WLMenuView *menuView;
@property (nonatomic,strong)UIButton *cencel;
@property (nonatomic,strong)UIView *cencelView;


- (void)star;

@end
