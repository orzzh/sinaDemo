//
//  wlBrowseViewController.h
//  sinaDemo
//
//  Created by wl on 2018/1/5.
//  Copyright https://github.com/orzzh All rights reserved.
//

#import "BaseViewController.h"
#import "WLScrollView.h"
#import "PhotoAssetModel.h"

@interface WLBrowseViewController : BaseViewController

@property (nonatomic,strong)NSArray<PhotoAssetModel *>   *selectPhotosAry;
@property (nonatomic,copy)NSArray<PhotoAssetModel *>     *photosAry;
@property (nonatomic,assign)NSInteger                    starIndex;
@property (nonatomic,strong)WLScrollView                 *wlScrView;
@property (nonatomic,assign)BOOL                         isPreView; //是否是预览模式
@property (copy)void(^selectBlock)(PhotoAssetModel *model);

@end
