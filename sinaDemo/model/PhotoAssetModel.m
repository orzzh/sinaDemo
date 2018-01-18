//
//  PhotoAssetModel.m
//  sinaDemo
//
//  Created by wl on 2018/1/4.
//  Copyright https://github.com/orzzh All rights reserved.
//

#import "PhotoAssetModel.h"

@implementation PhotoAssetModel

- (instancetype)initWithAsset:(PHAsset *)ass{
    self = [super init];
    if (self) {
        self.asset = ass;
        self.isSelected = NO;
        self.index_Row = -1;
    }
    return self;
}


@end
