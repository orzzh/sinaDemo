//
//  wlPhotoViewController.h
//  sinaDemo
//
//  Created by wl on 2018/1/4.
//  Copyright https://github.com/orzzh All rights reserved.
//

#import "BaseViewController.h"
@class PhotoAssetModel;
@interface WLPhotoViewController : BaseViewController

@property (nonatomic ,strong)UICollectionView *colloectView;
@property (nonatomic,strong)NSIndexPath *selectIndex;
@property (nonatomic,strong)NSArray<PhotoAssetModel*> *currueDataAry;



@end
