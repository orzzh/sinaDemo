//
//  toolScrollView.h
//  sinaDemo
//
//  Created by wl on 2018/1/10.
//  Copyright https://github.com/orzzh All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 
 滤镜 贴纸 集合视图
 
 **/

@interface toolScrollView : UIView

@property (nonatomic,strong)    NSArray *pasteAry;
@property (nonatomic,strong)    NSArray *filteAry;



@property (copy)void(^seletedBlock)(NSInteger index);

- (instancetype)initWithFrame:(CGRect)frame type:(NSInteger)type;

@end
