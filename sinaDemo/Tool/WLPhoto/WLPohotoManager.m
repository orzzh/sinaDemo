//
//  WLPohotoManager.m
//  sinaDemo
//
//  Created by WL on 2018/1/4.
//  Copyright https://github.com/orzzh All rights reserved.
//

#import "WLPohotoManager.h"

@implementation WLPohotoManager

+ (instancetype)sharedInstance
{
    static WLPohotoManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[WLPohotoManager alloc] init];
    });
    return manager;
}
+ (void)saveWithImage:(UIImage *)image{
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        //写入图片到相册
        [PHAssetChangeRequest creationRequestForAssetFromImage:image];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        NSLog(@"success = %d, error = %@", success, error);
        dispatch_async(dispatch_get_main_queue(), ^{
            [ToastManage showTopToastWith:@"保存成功"];
        });
    }];
}

-(NSMutableArray<PHAssetCollection*> *)getPhotoListDatas{
    NSMutableArray *dataArray = [NSMutableArray array];
    //    //获取资源时的参数，为nil时则是使用系统默认值
    //    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc]init];
    //    //列出所有的智能相册
    //    PHFetchResult *smartAlbumsFetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:fetchOptions];
    //    [dataArray addObject:[smartAlbumsFetchResult objectAtIndex:0]];
    //    //列出所有用户创建的相册
    //    PHFetchResult *smartAlbumsFetchResult1 = [PHAssetCollection fetchTopLevelUserCollectionsWithOptions:fetchOptions];
    PHFetchResult *smartAlbumsFetchResult1 = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    NSLog(@"%zd",smartAlbumsFetchResult1.count);
    for (PHAssetCollection *sub in smartAlbumsFetchResult1) {
        if ([sub.localizedTitle isEqualToString:@"相机胶卷"] ||
            [sub.localizedTitle isEqualToString:@"Camera Roll"]) {
            [dataArray insertObject:sub atIndex:0];
        }else if(![sub.localizedTitle isEqualToString:@"相机胶卷"] &&
                 ![sub.localizedTitle isEqualToString:@"已隐藏"] &&
                 ![sub.localizedTitle isEqualToString:@"视频"] &&
                 ![sub.localizedTitle isEqualToString:@"最近删除"] &&
                 ![sub.localizedTitle isEqualToString:@"Recently Deleted"] &&
                 ![sub.localizedTitle isEqualToString:@"Videos"] &&
                 ![sub.localizedTitle isEqualToString:@"Camera Roll"]){
            [dataArray addObject:sub];
        }
        
    }
    return dataArray;
}

//获取某个相册的结果集
-(PHFetchResult<PHAsset *> *)getFetchResult:(PHAssetCollection *)assetCollection ascend:(BOOL)ascend{
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0f) {
        options.includeAssetSourceTypes = PHAssetSourceTypeUserLibrary;
    }
    //时间排序
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:ascend]];
    PHFetchResult *allPhotos = [PHAsset fetchAssetsInAssetCollection:assetCollection options:options];
    return allPhotos;
}


+ (PHFetchResult<PHAsset *> *)getFetchResultWithMediaType:(PHAssetMediaType)mediaType ascend:(BOOL)ascend{
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0f) {
        options.includeAssetSourceTypes = PHAssetSourceTypeUserLibrary;
    }
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:ascend]];
    return  [PHAsset fetchAssetsWithMediaType:mediaType options:options];
}


-(NSMutableArray<PHAsset*> *)getPhotoAssets:(PHFetchResult *)fetchResult{
    NSMutableArray *dataArray = [NSMutableArray array];
    for (PHAsset *asset in fetchResult) {
        //只添加图片类型资源，去除视频类型资源
        //当mediatype == 2时，则视为视频资源
        if (asset.mediaType  == PHAssetMediaTypeImage) {
            
            [dataArray addObject:asset];
        }
    }
    return dataArray;
}

-(PHFetchResult<PHAsset *> *)getCameraRollFetchResulWithAscend:(BOOL)ascend{
    //获取系统相册CameraRoll 的结果集
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc]init];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0f) {
        fetchOptions.includeAssetSourceTypes = PHAssetSourceTypeUserLibrary;
    }
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:ascend]];
    PHFetchResult *smartAlbumsFetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
    PHFetchResult *fetch = [PHAsset fetchAssetsInAssetCollection:[smartAlbumsFetchResult objectAtIndex:0] options:fetchOptions];
    return fetch;
}


-(void)getImagesForAssets:(NSArray<PHAsset *> *)assets progressHandler:(void(^)(double progress, NSError * error, BOOL *stop, NSDictionary * info))progressHandler resultHandler:(void (^)(NSArray<NSDictionary *> *))resultHandler{
    
    NSMutableArray * callBackPhotos = [NSMutableArray array];
    
    //此处在子线程中执行requestImageForAsset原因：options.synchronous设为同步时,options.progressHandler获取主队列会死锁
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 1;
    
    for (PHAsset * asset in assets) {
        CGSize imageSize = [self imageSizeForAsset:asset];
        PHImageRequestOptions * options = [[PHImageRequestOptions alloc] init];
        //        options.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
        options.resizeMode = PHImageRequestOptionsResizeModeExact;
        options.networkAccessAllowed = YES;
        //同步保证取出图片顺序和选择的相同，deliveryMode默认为PHImageRequestOptionsDeliveryModeHighQualityFormat
        options.synchronous = YES;
        
        options.progressHandler = ^(double progress, NSError *__nullable error, BOOL *stop, NSDictionary *__nullable info){
            dispatch_async(dispatch_get_main_queue(), ^{
                progressHandler(progress,error,stop,info);
            });
        };
        
        NSBlockOperation * op = [NSBlockOperation blockOperationWithBlock:^{
            [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:imageSize contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                //resultHandler默认在主线程，requestImageForAsset在子线程执行后resultHandler变为在子线程
                if (result) {
                    //压缩图片，可用于上传
                    NSData * data = [UIImage resetSizeOfImageData:result compressQuality:0.2];
                    UIImage * image = [UIImage imageWithData:data];
                    NSDictionary * dic = @{EEPhotoImage:image,EEPhotoName:asset.localIdentifier};
                    [callBackPhotos addObject:dic];
                    if (resultHandler && callBackPhotos.count == assets.count) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            resultHandler(callBackPhotos);
                        });
                    }
                }
            }];
        }];
        [queue addOperation:op];
    }
}


-(void)getImageHighQualityForAsset:(PHAsset *)asset progressHandler:(void(^)(double progress, NSError * error, BOOL *stop, NSDictionary * info))progressHandler resultHandler:(void (^)(UIImage* result, NSDictionary * info))resultHandler{
    
    CGSize imageSize = [self imageSizeForAsset:asset];
    PHImageRequestOptions * options = [[PHImageRequestOptions alloc] init];
    //设置该模式，若本地无高清图会立即返回缩略图，需要从iCloud下载高清，会再次调用resultHandler返回下载后的高清图
    options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    options.networkAccessAllowed = YES;
    options.progressHandler = ^(double progress, NSError *__nullable error, BOOL *stop, NSDictionary *__nullable info){
        
        if (progressHandler) {
            dispatch_async(dispatch_get_main_queue(), ^{
                progressHandler(progress,error,stop,info);
            });
        }
    };
    
    [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:imageSize contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        //判断高清图
        //   BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
        if (result && resultHandler) {
            resultHandler(result,info);
        }
    }];
}

-(void)getImageLowQualityForAsset:(PHAsset *)asset targetSize:(CGSize)targetSize resultHandler:(void (^)(UIImage* result, NSDictionary * info))resultHandler{
    PHImageRequestOptions * options = [[PHImageRequestOptions alloc] init];
    //设置该模式，若本地无高清图会立即返回缩略图，需要从iCloud下载高清，会再次调用resultHandler返回下载后的高清图
    options.deliveryMode=PHImageRequestOptionsDeliveryModeOpportunistic;
    options.synchronous = YES;
    
    [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if (result && resultHandler) {
            resultHandler(result,info);
        }
    }];
    
}


+(void)requestAuthorizationHandler:(void(^)(BOOL isAuthorized))handler {
    
    if (handler) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (status == PHAuthorizationStatusAuthorized) {
                    handler(YES);
                }else{
                    handler(NO);
                }
            });
        }];
    }
}

-(CGSize)imageSizeForAsset:(PHAsset *)asset{
    CGFloat photoWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat multiple = [UIScreen mainScreen].scale;
    CGFloat aspectRatio = asset.pixelWidth / (CGFloat)asset.pixelHeight;
    CGFloat pixelWidth = photoWidth * multiple;
    CGFloat pixelHeight = pixelWidth / aspectRatio;
    return  CGSizeMake(pixelWidth, pixelHeight);
}


-(NSMutableArray<PHAsset*> *)getVideoAssets:(PHFetchResult *)fetchResult{
    NSMutableArray *dataArray = [NSMutableArray array];
    for (PHAsset *asset in fetchResult) {
        //只添加图片类型资源，去除视频类型资源
        //当mediatype == 2时，则视为视频资源
        if (asset.mediaType  == PHAssetMediaTypeVideo) {
            
            [dataArray addObject:asset];
        }
    }
    return dataArray;
}

@end
