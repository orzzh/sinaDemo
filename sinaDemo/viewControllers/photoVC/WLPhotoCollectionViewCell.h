//
//  wlPhotoCollectionViewCell.h
//  sinaDemo
//
//  Created by wl on 2018/1/4.
//  Copyright https://github.com/orzzh All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoAssetModel.h"
#import "SelectBox.h"

@protocol WLPhotoCollectionViewCellDelegate<NSObject>


/**
 状态切换

 @param index 数据源index
 */
- (void)didSelectStateChanageAtIndex:(NSInteger)index;

@end

@interface WLPhotoCollectionViewCell : UICollectionViewCell

@property (weak) id<WLPhotoCollectionViewCellDelegate> delegate;
@property (nonatomic,strong)UIImageView *imgView;
@property (nonatomic,strong)SelectBox   *seletBtn;

- (void)setModel:(PhotoAssetModel *)model;


@end
