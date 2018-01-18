//
//  VideoTool.h
//  poto
//
//  Created by wl on 2017/12/1.
//  Copyright © 2017年 wl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoModel.h"

typedef void(^SuccessBlock)(BOOL isSuccess,NSString *outPath,NSData *videoData);



@interface VideoTool : NSObject


/**
 保存视频
 
 @param url 视频地址
 */
+ (void)saveVideoWithURL:(NSURL *)url;

/**
 返回数据模型
 
 @param url 视频地址
 @return VideoModel
 */

+ (VideoModel *)getModelWithURL:(NSURL *)url;

/**
 返回数据模型
 
 @param asset 资源对象
 @return VideoModel
 */
+ (VideoModel *)getModelWithAsset:(PHAsset *)asset;


/**
 普通视频压缩
 
 @param path 路径
 @param successBlock 成功回调
 @return 压缩类
 */
+ (AVAssetExportSession *)getVideoWithPath:(NSString *)path SuccessBlock:(SuccessBlock)successBlock;

/**
 拍照裁剪压缩
 
 @param path 路径
 @param successBlock 成功回调
 @return 压缩类
 */
+ (AVAssetExportSession *)getCutVideoWithPath:(NSString *)path SuccessBlock:(SuccessBlock)successBlock;

/**
 长视频截取片段压缩
 
 @param path 路径
 @param successBlock 成功回调
 @return 压缩类
 */
+ (AVAssetExportSession *)getLongVideoWithPath:(NSString *)path starTime:(CGFloat)starTime endTime:(CGFloat)endTime SuccessBlock:(SuccessBlock)successBlock;

/**
 清除本地压缩视频文件
 */

+ (void)deleteAllCompressVideo;

+ (NSString *)getOutPath;
@end
