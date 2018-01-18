//
//  VideoModel.h
//  poto
//
//  Created by wl on 2017/11/30.
//  Copyright © 2017年 wl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WLPohotoManager.h"
@interface VideoModel : NSObject

@property (nonatomic,copy)   NSString    *videoTime;      //时长 HHMMSS
@property (nonatomic,strong) UIImage     *videoFace;      //封面
@property (nonatomic,assign) AVURLAsset  *videoAsset;     //视频对象
@property (nonatomic,copy)   NSString    *videoPath;      //视频相册地址
@property (nonatomic,copy)   NSString    *videoOutPutPath;//视频相册地址
@property (nonatomic,strong) NSData      *videoData;      //压缩视频
@property (nonatomic,assign) CGFloat     videoSize;       //原视频大小
@property (nonatomic,assign) int         videoDuration;   // 时间 单位秒

@end
