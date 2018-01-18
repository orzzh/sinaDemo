//
//  VideoMaxTool.m
//  VideoRecordText
//
//  Created by wl on 2017/12/21.
//  Copyright © 2017年 zzjd. All rights reserved.
//

#import "VideoMaxTool.h"

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

#import "VideoTool.h"

@implementation VideoMaxTool

+ (void)videoMixWithURLs:(NSArray *)urls outPath:(NSString *)outPath block:(void(^)(NSURL *))finshed{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
        
        AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
        
        AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                            preferredTrackID:kCMPersistentTrackID_Invalid];
        AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                            preferredTrackID:kCMPersistentTrackID_Invalid];
        
        CMTime totalDuration = kCMTimeZero;
        
        for (int i = 0; i < urls.count; i++) {
            AVURLAsset *asset = [AVURLAsset assetWithURL:urls[i]];
            NSError *erroraudio = nil;//获取AVAsset中的音频 或者视频
            AVAssetTrack *assetAudioTrack = [[asset tracksWithMediaType:AVMediaTypeAudio] firstObject];//向通道内加入音频或者视频
            //BOOL ba =
            [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                                ofTrack:assetAudioTrack
                                 atTime:totalDuration
                                  error:&erroraudio];
            
            //NSLog(@"erroraudio:%@%d",erroraudio,ba);
            NSError *errorVideo = nil;
            AVAssetTrack *assetVideoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo]firstObject];
            
            //BOOL bl =
            [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                                ofTrack:assetVideoTrack
                                 atTime:totalDuration
                                  error:&errorVideo];
            
            //NSLog(@"errorVideo:%@%d",errorVideo,bl);
            totalDuration = CMTimeAdd(totalDuration, asset.duration);
            
            videoComposition.frameDuration = CMTimeMake(1, 30);
            //视频输出尺寸
            CGFloat renderSizeWidth=assetVideoTrack.naturalSize.height;
            CGFloat renderSizeHeight=assetVideoTrack.naturalSize.height;
            
            videoComposition.renderSize = CGSizeMake(renderSizeHeight,renderSizeWidth);
            //渲染大小
            CALayer *parentLayer = [CALayer layer];
            CALayer *videoLayer = [CALayer layer];
            videoLayer.frame = CGRectMake(0,0, renderSizeHeight, renderSizeWidth);
            parentLayer.frame = CGRectMake(0,0,renderSizeHeight, renderSizeWidth);
            [parentLayer addSublayer:videoLayer];
            videoComposition.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
            
            AVMutableVideoCompositionInstruction * avMutableVideoCompositionInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
            
            [avMutableVideoCompositionInstruction setTimeRange:CMTimeRangeMake(kCMTimeZero, [mixComposition duration])];
            
            AVMutableVideoCompositionLayerInstruction * avMutableVideoCompositionLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:assetAudioTrack];
            
            [avMutableVideoCompositionLayerInstruction setTransform:assetVideoTrack.preferredTransform atTime:kCMTimeZero];
            
            avMutableVideoCompositionInstruction.layerInstructions = [NSArray arrayWithObject:avMutableVideoCompositionLayerInstruction];
            
            videoComposition.instructions = [NSArray arrayWithObject:avMutableVideoCompositionInstruction];
            
            
        }
        
        NSFileManager* fileManager=[NSFileManager defaultManager];
        BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:outPath];
        if (blHave) {
            [fileManager removeItemAtPath:outPath error:nil];
        }
        
        
        NSURL *mergeFileURL = [NSURL fileURLWithPath:outPath];
        //        NSLog(@"starvideorecordVC: 345 outpath = %@",outpath);
        AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetMediumQuality];
        exporter.outputURL = mergeFileURL;
        
        exporter.videoComposition = videoComposition;
        exporter.outputFileType = AVFileTypeMPEG4;
        exporter.shouldOptimizeForNetworkUse = YES;
        [exporter exportAsynchronouslyWithCompletionHandler:^{
            NSLog(@" exporter%@",exporter.error);
            if (exporter.status == AVAssetExportSessionStatusCompleted) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                 //回调
                    finshed(mergeFileURL);
                });
            }
        }];
        
        
    });
    
}

@end
