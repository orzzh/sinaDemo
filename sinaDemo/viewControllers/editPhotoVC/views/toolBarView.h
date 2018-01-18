//
//  toolBarView.h
//  sinaDemo
//
//  Created by wl on 2018/1/10.
//  Copyright https://github.com/orzzh All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 
 底部工具bar
 
 **/
@interface toolBarView : UIView

@property (copy)void(^seletedBlock)(NSInteger index);

@end
