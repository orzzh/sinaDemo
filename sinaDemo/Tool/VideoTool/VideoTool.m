//
//  VideoTool.m
//  poto
//
//  Created by wl on 2017/12/1.
//  Copyright © 2017年 wl. All rights reserved.
//

#import "VideoTool.h"
#import "WLPohotoManager.h"


@implementation VideoTool

+ (void)saveVideoWithURL:(NSURL *)url{
    //视频录制完成之后在后台将视频存储到相簿
    NSError *error;
    PHPhotoLibrary *photo = [PHPhotoLibrary sharedPhotoLibrary];
    [photo performChangesAndWait:^{
        [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:url];
        NSLog(@"保存完毕");
        [ToastManage showTopToastWith:@"保存成功"];

    } error:&error];
    if (error) {
        NSLog(@"发生错误 %@",error.localizedFailureReason);
    }
}



+ (VideoModel *)getModelWithURL:(NSURL *)url{
    
    VideoModel *model = [[VideoModel alloc]init];
    
    //获取封面图
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    
    //获取时长
    CMTime   time1 = [asset duration];
    int seconds = ceil(time1.value/time1.timescale);
    
    //获取大小
    NSNumber *fileSizeValue = nil;
    [asset.URL getResourceValue:&fileSizeValue forKey:NSURLFileSizeKey error:nil];
    model.videoDuration = seconds;
    model.videoFace = thumb;
    model.videoSize = [fileSizeValue floatValue]/1024.0/1024.0;
    model.videoPath = [NSString stringWithFormat:@"%@",url.absoluteString];
    return model;
}


+ (VideoModel *)getModelWithAsset:(PHAsset *)asset{
    
    VideoModel *model = [[VideoModel alloc]init];

    //获取图片
    [[WLPohotoManager sharedInstance] getImageLowQualityForAsset:asset targetSize:CGSizeMake(375, 500) resultHandler:^(UIImage *result, NSDictionary *info) {
        model.videoFace = result;
    }];
    
    //获取时长
    [[PHImageManager defaultManager]requestAVAssetForVideo:asset options:nil resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        model.videoTime = [VideoTool returndate:(int)CMTimeGetSeconds(asset.duration)];
        CMTime   time = [asset duration];
        model.videoDuration = ceil(time.value/time.timescale);
        AVURLAsset *urlAsset = (AVURLAsset *)asset;
        model.videoPath = [NSString stringWithFormat:@"%@",urlAsset.URL];
        model.videoAsset = urlAsset;
        NSNumber *fileSizeValue = nil;
        [urlAsset.URL getResourceValue:&fileSizeValue forKey:NSURLFileSizeKey error:nil];
        model.videoSize = [fileSizeValue floatValue]/1024.0/1024.0;
    }];
    return model;
}

#pragma mark - 仅压缩
+ (AVAssetExportSession *)getVideoWithPath:(NSString *)path SuccessBlock:(SuccessBlock)successBlock{
    //资源
    AVURLAsset* asset = [AVURLAsset assetWithURL:[NSURL URLWithString:path]];
    //时间
    CMTime   time = [asset duration];
    int seconds = ceil(time.value/time.timescale);
    //轨道
    AVAssetTrack *clipVideoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    CGFloat renderSizeWidth=clipVideoTrack.naturalSize.height;
    CGFloat renderSizeHeight=clipVideoTrack.naturalSize.width;
    
    return [VideoTool getCutVideoWithPath:asset starTime:0 endTime:seconds renderSizeWidth:renderSizeWidth renderSizeHeight:renderSizeHeight clipVideoTrack:clipVideoTrack SuccessBlock:successBlock];
}

#pragma mark - 拍摄视频裁剪并压缩
+ (AVAssetExportSession *)getCutVideoWithPath:(NSString *)path SuccessBlock:(SuccessBlock)successBlock{
    //资源
    AVURLAsset* asset = [AVURLAsset assetWithURL:[NSURL URLWithString:path]];
    //时间
    CMTime   time = [asset duration];
    int seconds = ceil(time.value/time.timescale);
    //轨道
    AVAssetTrack *clipVideoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    CGFloat renderSizeWidth=clipVideoTrack.naturalSize.height*4/3;
    CGFloat renderSizeHeight=clipVideoTrack.naturalSize.height;
    
    return [VideoTool getCutVideoWithPath:asset starTime:0 endTime:seconds renderSizeWidth:renderSizeWidth renderSizeHeight:renderSizeHeight clipVideoTrack:clipVideoTrack SuccessBlock:successBlock];
}

#pragma mark - 选择超长视频压缩
+ (AVAssetExportSession *)getLongVideoWithPath:(NSString *)path starTime:(CGFloat)starTime endTime:(CGFloat)endTime SuccessBlock:(SuccessBlock)successBlock{
    
    //资源
    AVURLAsset* asset = [AVURLAsset assetWithURL:[NSURL URLWithString:path]];
    //轨道
    AVAssetTrack *clipVideoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    CGFloat renderSizeWidth=clipVideoTrack.naturalSize.height;
    CGFloat renderSizeHeight=clipVideoTrack.naturalSize.width;
    
   return [VideoTool getCutVideoWithPath:asset starTime:starTime endTime:endTime renderSizeWidth:renderSizeWidth renderSizeHeight:renderSizeHeight clipVideoTrack:clipVideoTrack SuccessBlock:successBlock];
}


+ (void)deleteAllCompressVideo{
    //沙盒路径
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *videoPath = [NSString stringWithFormat:@"%@/", pathDocuments];
    
    //文件管理类
    NSFileManager *manager = [NSFileManager defaultManager];

    //获取目录下文件
    NSArray *tempFileList = [[NSArray alloc] initWithArray:[manager contentsOfDirectoryAtPath:videoPath error:nil]];
    
    //删除缓存的 压缩视频
    if (tempFileList && tempFileList.count == 0) {
        return;
    }
    for (NSString *file in tempFileList) {
        if ([file rangeOfString:@".mov"].location != NSNotFound ||
            [file rangeOfString:@".wav"].location != NSNotFound ) {
            BOOL res = [manager removeItemAtPath:[videoPath stringByAppendingString:file] error:nil];
            if (res) {
                NSLog(@"删除成功！ %@",file);
            }else{
                NSLog(@"删除失败！ %@",file);
            }
        }
    }
}

#pragma mark - 私有方法

+ (NSString *)returndate:(int)num{
    
    int seconds = num % 60;
    int minutes = (num / 60) % 60;
    int hours = num / 3600;
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}

+ (NSString *)getOutPath{
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd_hh:mm:ss"];
    NSString *DateTime = [formatter stringFromDate:date];
    
    //  //保存至沙盒路径
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *outPutPath = [NSString stringWithFormat:@"%@/%@.mp4", pathDocuments,DateTime];
    return outPutPath;
}

+ (AVAssetExportSession *)getCutVideoWithPath:(AVURLAsset *)asset starTime:(CGFloat)starTime endTime:(CGFloat)endTime renderSizeWidth:(CGFloat)renderSizeWidth renderSizeHeight:(CGFloat)renderSizeHeight clipVideoTrack:(AVAssetTrack *)clipVideoTrack SuccessBlock:(SuccessBlock)successBlock{
    
    AVMutableVideoComposition* videoComposition = [VideoTool getAVMutableVideoCompositionWithrenderSizeWidth:renderSizeWidth renderSizeHeight:renderSizeHeight asset:asset clipVideoTrack:clipVideoTrack];
    
    NSString *outPath = [VideoTool getOutPath];
    NSURL *outPutURL = [NSURL fileURLWithPath:outPath];
    
    //压缩裁剪并导出 高质量压缩
    AVAssetExportSession *exportSession = [VideoTool getAVAssetExportSessionWithAVURLAsset:asset starTime:starTime endTime:endTime videoComposition:videoComposition outPath:outPath];
    
    if (renderSizeHeight != clipVideoTrack.naturalSize.width) {
        //是拍摄视频
        exportSession.shouldOptimizeForNetworkUse = YES;
        [exportSession setVideoComposition:videoComposition];
    }
    
    __block BOOL copyOK = NO;
    __block NSData *videoData;
    
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        if (exportSession.status == AVAssetExportSessionStatusCompleted) {
            copyOK=YES;
            NSLog(@"视频压缩转码成功");
            videoData = [NSData dataWithContentsOfFile:outPath];
            CGFloat  fileSize = [[NSFileManager defaultManager] attributesOfItemAtPath:outPath error:nil].fileSize;
            NSLog(@"压缩后大小 %f",fileSize/1024.0/1024.0);
            if (successBlock) {
                successBlock(YES,outPath,videoData);
            }
        }if (exportSession.status == AVAssetExportSessionStatusFailed) {
            NSLog(@"AVAssetExportSessionStatusFailed");
            NSLog(@"压缩出错");
        }
        
    }];
    return exportSession;
}

+ (AVMutableVideoComposition *)getAVMutableVideoCompositionWithrenderSizeWidth:(CGFloat)renderSizeWidth renderSizeHeight:(CGFloat)renderSizeHeight asset:(AVURLAsset *)asset clipVideoTrack:(AVAssetTrack *)clipVideoTrack{
   
    AVMutableVideoComposition* videoComposition = [AVMutableVideoComposition videoComposition];
    videoComposition.frameDuration = CMTimeMake(1, 30);
    //视频宽高
    videoComposition.renderSize =CGSizeMake(renderSizeHeight,renderSizeWidth);
    //渲染大小
    CALayer *parentLayer = [CALayer layer];
    CALayer *videoLayer = [CALayer layer];
    videoLayer.frame = CGRectMake(0,0, renderSizeHeight, renderSizeWidth);
    parentLayer.frame = CGRectMake(0,0,renderSizeHeight, renderSizeWidth);
    [parentLayer addSublayer:videoLayer];
    videoComposition.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    //时间裁剪
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, asset.duration);
    AVMutableVideoCompositionLayerInstruction *avMutableVideoCompositionLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:clipVideoTrack];
    CGAffineTransform t1=clipVideoTrack.preferredTransform;
    t1 = CGAffineTransformTranslate(t1, 0,0);
    [avMutableVideoCompositionLayerInstruction setTransform:t1 atTime:kCMTimeZero];
    instruction.layerInstructions = [NSArray arrayWithObject:avMutableVideoCompositionLayerInstruction];
    videoComposition.instructions = [NSArray arrayWithObject:instruction];
    return videoComposition;
}

+ (AVAssetExportSession *)getAVAssetExportSessionWithAVURLAsset:(AVURLAsset *)asset starTime:(CGFloat)starTime endTime:(CGFloat)endTime videoComposition:(AVMutableVideoComposition *)videoComposition outPath:(NSString *)outPath{
    //压缩裁剪并导出 高质量压缩
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetHighestQuality];
    //裁剪时间区间
    CMTime start = CMTimeMakeWithSeconds((int)starTime, asset.duration.timescale);
    CMTime duration = CMTimeMakeWithSeconds((int)endTime-(int)starTime, asset.duration.timescale);
    
    //
    NSLog(@"fanwei %d %d",(int)starTime,(int)endTime-(int)starTime);
    CMTimeRange range = CMTimeRangeMake(start, duration);
    exportSession.timeRange = range;
    //输出路径
    NSURL *outPutURL = [NSURL fileURLWithPath:outPath];
    exportSession.outputURL = outPutURL;
    //输出mp4
    exportSession.outputFileType = AVFileTypeMPEG4;
    
    //时间
    CMTime   time = [asset duration];
    int seconds = ceil(time.value/time.timescale);
    if (starTime != 0 && seconds != endTime) {
        NSLog(@"仅压缩不裁剪 不设置videoComposition");
        NSLog(@"拍摄要设置");
        [exportSession setVideoComposition:videoComposition];
    }
    return exportSession;
}
@end
