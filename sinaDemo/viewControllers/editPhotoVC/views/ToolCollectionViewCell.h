//
//  ToolCollectionViewCell.h
//  sinaDemo
//
//  Created by wl on 2018/1/10.
//  Copyright https://github.com/orzzh All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToolCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong)UIImageView *imageView;

@property (nonatomic,strong)UILabel *titleView;

@property (nonatomic,strong)CALayer *borderLayer;


- (void)deful;

- (void)selected;
    
@end
