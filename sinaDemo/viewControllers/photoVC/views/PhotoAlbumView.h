//
//  PhotoAlbumView.h
//  sinaDemo
//
//  Created by wl on 2018/1/8.
//  Copyright https://github.com/orzzh All rights reserved.
//

#import <UIKit/UIKit.h>
@class PhotoVolumeModel;
@interface PhotoAlbumView : UIView

@property (copy)void(^block)(PhotoVolumeModel *volumeModel);
/**
    相册框打开关闭
 */
- (void)open;

@end
