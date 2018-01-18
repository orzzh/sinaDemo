//
//  AlbumTableViewCell.m
//  sinaDemo
//
//  Created by wl on 2018/1/11.
//  Copyright https://github.com/orzzh All rights reserved.
//

#import "AlbumTableViewCell.h"
#import "wlPohotoManager.h"

@interface AlbumTableViewCell ()

@property (nonatomic,strong)UIImageView *titleImage;
@property (nonatomic,strong)UILabel *titlelbl;

@end
@implementation AlbumTableViewCell


- (void)setPhotoVolumeModel:(PhotoVolumeModel *)model{
    self.titlelbl.text = [NSString stringWithFormat:@"%@·%zd",model.volumeTitle,model.photoAry.count];
    
    //相册为空
    if (model.photoAry.count == 0) {
//        self.titleImage.image = [UIImage imageNamed:@"默认"];
        return;
    }
    
    
    PhotoAssetModel *asset = model.photoAry[0];
    WeakSelf;
    [[WLPohotoManager sharedInstance]getImageLowQualityForAsset:asset.asset targetSize:CGSizeMake((SCREEN_WIDTH-3)/4,(SCREEN_WIDTH-3)/4) resultHandler:^(UIImage *result, NSDictionary *info) {
        weakSelf.titleImage.image = result;
    }];
}




- (UIImageView *)titleImage{
    if (!_titleImage) {
        _titleImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 5, 50, 50)];
        _titleImage.backgroundColor = [UIColor  blackColor];
        _titleImage.layer.masksToBounds = YES;
        _titleImage.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_titleImage];
    }
    return _titleImage;
}

- (UILabel *)titlelbl{
    if (!_titlelbl) {
        _titlelbl = [[UILabel alloc]initWithFrame:CGRectMake(self.titleImage.originX+self.titleImage.width+10 , 5, 300, self.height)];
        _titlelbl.font = FONTSIZE(14);
        _titlelbl.textColor = COLOR_GR(0.8);
        [self addSubview:_titlelbl];
    }
    return _titlelbl;
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
