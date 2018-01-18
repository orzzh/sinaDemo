//
//  VideoMaxTool.h
//  VideoRecordText
//
//  Created by wl on 2017/12/21.
//  Copyright © 2017年 zzjd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoMaxTool : UIView


+ (void)videoMixWithURLs:(NSArray *)urls outPath:(NSString *)outPath block:(void(^)(NSURL *))finshed;


@end
