//
//  PasteView.h
//  sinaDemo
//
//  Created by wl on 2018/1/10.
//  Copyright https://github.com/orzzh All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 
 贴纸view 旋转 放大缩小
 
 **/
@interface PasteView : UIView

@property (copy)void(^deleteBlock)(NSInteger);
@property (nonatomic,strong)UIImageView *pasteImage;

- (void)hideEdit;

@end
