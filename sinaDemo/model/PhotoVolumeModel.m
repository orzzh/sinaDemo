//
//  PhotoVolumeModel.m
//  sinaDemo
//
//  Created by WL on 2018/1/4.
//  Copyright https://github.com/orzzh All rights reserved.
//

#import "PhotoVolumeModel.h"

@implementation PhotoVolumeModel


+ (PhotoVolumeModel *)getCameraRollVolume{
    WLPohotoManager *manage = [WLPohotoManager sharedInstance];
    //所有相册
    NSMutableArray *listAry = [manage getPhotoListDatas];
    //相机相册
    PHAssetCollection *collection = [listAry objectAtIndex:0];
    return [PhotoVolumeModel getVolumeModelWith:collection];
}


+ (NSArray <PhotoVolumeModel *>*)getVolumeModels{
    WLPohotoManager *manage = [WLPohotoManager sharedInstance];
    NSMutableArray *ary = [[NSMutableArray alloc]init];
    
    //所有相册
    NSMutableArray *listAry = [manage getPhotoListDatas];
    for (PHAssetCollection *collection in listAry) {
        PhotoVolumeModel *m = [PhotoVolumeModel getVolumeModelWith:collection];
//        if (m.photoAry.count != 0) {
            [ary addObject:m];
//        }
    }
    return ary;
}



+ (PhotoVolumeModel *)getVolumeModelWith:(PHAssetCollection *)collection{
    
    PhotoVolumeModel *model = [[PhotoVolumeModel alloc]init];
    WLPohotoManager *manage = [WLPohotoManager sharedInstance];

    //相册名
    model.volumeTitle = [NSString stringWithFormat:@"%@",collection.localizedTitle];
    //相册结果集
    PHFetchResult *resultAry = [manage getFetchResult:collection ascend:NO];
    //照片对象数组
    NSArray *assetAry = [manage getPhotoAssets:resultAry];
    //照片数组初始化 照片对象模型
    NSMutableArray *tempAry = [[NSMutableArray alloc]init];
    for (int i = 0; i<assetAry.count; i++) {
        PHAsset *asset = assetAry[i];
        PhotoAssetModel *m = [[PhotoAssetModel alloc]initWithAsset:asset];
        [tempAry addObject:m];
    }
    model.photoAry = [[NSMutableArray alloc]initWithArray:tempAry];
    
    return model;
}




- (instancetype)init{
    self = [super init];
    if (self) {
        _photoAry = [[NSMutableArray alloc]init];
    }
    return self;
}
@end
