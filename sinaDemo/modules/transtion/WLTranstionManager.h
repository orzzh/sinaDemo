//
//  WLTranstionManager.h
//  sinaDemo
//
//  Created by WL on 2018/1/3.
//  Copyright https://github.com/orzzh All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,WLTranstionMode) {
    WLTranstionModePop = 1,
    WLTranstionModePush,
    WLTranstionModePresent,
    WLTranstionModeDismiss
};

typedef NS_ENUM(NSInteger,WLTranstionType) {
    //菜单转场
    WLTranstionTypeMenu = 1,
    //相册转场
    WLTranstionTypePhoto

};

@interface WLTranstionManager : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic)WLTranstionMode transtionMode;


/**
 类方法

 @param type 转场效果
 @param mode pop／present
 @return 子类
 */
+ (instancetype)managerWithtype:(WLTranstionType)type model:(WLTranstionMode)mode;


/**
 子类初始化

 @param mode pop／present
 @return self
 */
- (instancetype)initWithModel:(WLTranstionMode)mode;



@end
