//
//  EditPhotoViewController.h
//  sinaDemo
//
//  Created by wl on 2018/1/10.
//  Copyright https://github.com/orzzh All rights reserved.
//

#import "EditBaseViewController.h"
#import "PhotoAssetModel.h"

/**
    主要编辑处理页面：处理页面转换、添加标签 滤镜 旋转
 */
@interface EditPhotoViewController : EditBaseViewController

@property (nonatomic,strong)PhotoAssetModel *model; //相册选取的图片
@property (nonatomic,strong)UIImage *imgCamear;     //拍照照片

@end
