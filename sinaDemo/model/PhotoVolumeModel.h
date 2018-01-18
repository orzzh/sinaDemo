//
//  PhotoVolumeModel.h
//  sinaDemo
//
//  Created by wl on 2018/1/4.
//  Copyright https://github.com/orzzh All rights reserved.
//

#import <Foundation/Foundation.h>
#import "wlPohotoManager.h"
#import "PhotoAssetModel.h"

@interface PhotoVolumeModel : NSObject

@property (nonatomic,copy)NSString *volumeTitle;     //相册名

@property (nonatomic,copy)NSMutableArray<PhotoAssetModel*> *photoAry;  //相片资源数组


/**
 获取系统相册
 
 @return model
 */
+ (PhotoVolumeModel *)getCameraRollVolume;


/**
 获取模型化 相册集

 @return ary
 */
+ (NSArray <PhotoVolumeModel *>*)getVolumeModels;

@end
