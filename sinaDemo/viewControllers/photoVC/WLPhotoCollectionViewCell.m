//
//  wlPhotoCollectionViewCell.m
//  sinaDemo
//
//  Created by wl on 2018/1/4.
//  Copyright https://github.com/orzzh All rights reserved.
//

#import "WLPhotoCollectionViewCell.h"
#import "WLPohotoManager.h"
@interface WLPhotoCollectionViewCell()
{
    UIView *make;
}
@property (nonatomic,strong)PhotoAssetModel *model;

@end
@implementation WLPhotoCollectionViewCell


- (void)setModel:(PhotoAssetModel *)model{
    _model = model;
    WeakSelf;
    [[WLPohotoManager sharedInstance]getImageLowQualityForAsset:model.asset targetSize:CGSizeMake((SCREEN_WIDTH-3)/4,(SCREEN_WIDTH-3)/4) resultHandler:^(UIImage *result, NSDictionary *info) {
        weakSelf.imgView.image = result;
    }];
    
    [self refreshCellState];
}

- (void)refreshCellState{
    self.seletBtn.selected = _model.isSelected;
    make.hidden = !_model.isSelected;
}

- (void)selectedAct:(UIButton *)sender{
    make.hidden = sender.selected;
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(didSelectStateChanageAtIndex:)]) {
        [self.delegate didSelectStateChanageAtIndex:_model.index_Row];
    }
}





- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]initWithFrame:self.bounds];
        _imgView.userInteractionEnabled = YES;
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.layer.masksToBounds = YES;
        [self addSubview:_imgView];
        
        make = [[UIView alloc]initWithFrame:self.bounds];
        make.backgroundColor = COLOR_GR(0.3);
        make.hidden = YES;
        [_imgView addSubview:make];
        
        CGFloat width  = 22;
        CGFloat pading = 5;
        _seletBtn = [[SelectBox alloc]initWithFrame:CGRectMake(self.width-width-pading, pading, width, width)];
        [_seletBtn addTarget:self action:@selector(selectedAct:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_seletBtn];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshCellState) name:@"refreshCellState" object:nil];
    }
    return _imgView;
}

@end
