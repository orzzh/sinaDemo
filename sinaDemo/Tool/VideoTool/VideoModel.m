//
//  VideoModel.m
//  poto
//
//  Created by wl on 2017/11/30.
//  Copyright © 2017年 wl. All rights reserved.
//

#import "VideoModel.h"
#define CELL_WIDTH (SCREEN_WIDTH-16)/3

@implementation VideoModel

- (NSString *)videoTime{
    if (!_videoTime) {

        _videoTime = @"00:00";
    }
    return _videoTime;
}

@end
