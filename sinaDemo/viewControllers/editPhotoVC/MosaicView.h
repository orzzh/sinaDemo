//
//  MosaicView.h
//  sinaDemo
//
//  Created by wl on 2018/1/12.
//  Copyright https://github.com/orzzh All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MosaicView : UIView

/**
    马赛克处理过的图.
 */
@property (nonatomic, strong) UIImage *image;
/**
    原图.
 */
@property (nonatomic, strong) UIImage *surfaceImage;

/**
    宽度
 */
@property (nonatomic,assign) CGFloat lineWidth;

/**
    是否可画
 */
@property (nonatomic,assign) BOOL isOpen;


- (void)removePath;

@end
