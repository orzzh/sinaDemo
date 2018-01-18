//
//  PhotoAssetModel.h
//  sinaDemo
//
//  Created by wl on 2018/1/4.
//  Copyright https://github.com/orzzh All rights reserved.
//

#import <UIKit/UIKit.h>
#import "wlPohotoManager.h"

@interface PhotoAssetModel : UIView

@property (nonatomic,strong)PHAsset *asset; //图片资源

@property (nonatomic,assign)BOOL isSelected; //是否选中

@property (nonatomic,assign)NSInteger index_Row;//标志位

- (instancetype)initWithAsset:(PHAsset *)ass;

@end
