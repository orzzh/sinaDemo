//
//  wlBrowseViewCell.h
//  sinaDemo
//
//  Created by wl on 2018/1/5.
//  Copyright https://github.com/orzzh All rights reserved.
//


#import "WLSubView.h"
#import "PhotoAssetModel.h"
@interface WLBrowseViewCell : WLSubView


@property (nonatomic,strong)UIImageView *imageView;

#pragma mark - 用于转场动画

@property (nonatomic,assign)CGRect imageRect;     //imageView frame
@property (nonatomic,assign)NSInteger index_row; //当前cell 数据源标志为止

- (void)setModel:(PhotoAssetModel *)model frame:(CGRect)frame;


@end
