//
//  wlBrowseViewCell.m
//  sinaDemo
//
//  Created by wl on 2018/1/5.
//  Copyright https://github.com/orzzh All rights reserved.
//

#import "WLBrowseViewCell.h"
#import "WLPohotoManager.h"

@interface WLBrowseViewCell()

@property (nonatomic,strong) UIScrollView *mainScrollView;//包装单个图片的scrollView

@end
@implementation WLBrowseViewCell

- (instancetype)initWithFrame:(CGRect)frame Identifier:(NSString *)indentifier{
    self = [super initWithFrame:frame Identifier:indentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)setModel:(PhotoAssetModel *)model frame:(CGRect)frame{
    self.index_row = model.index_Row;
    WeakSelf;
    [[WLPohotoManager sharedInstance] getImageLowQualityForAsset:model.asset targetSize:CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH/model.asset.pixelWidth*frame.size.height) resultHandler:^(UIImage *result, NSDictionary *info) {
        [weakSelf checkSize:result];
    }];
}

- (void)checkSize:(UIImage *)image{
    //根据image宽高算imageview的宽高
    CGSize imageSize = image.size;
    CGFloat imageViewWidth = SCREEN_WIDTH;
    CGFloat imageViewHeight = imageSize.height / imageSize.width * imageViewWidth;//等于是按比例算出满宽时的高
    self.imageView.width = imageViewWidth;
    self.imageView.height = imageViewHeight;
    self.imageView.image = image;
    if (imageViewWidth >= imageViewHeight) {
        self.imageView.center = [self centerOfScrollViewContent:_mainScrollView];
    }else{
        self.imageView.originX = 0;
        self.imageView.originY = 0;
    }
    _mainScrollView.contentSize = self.imageView.frame.size;
    self.imageRect = self.imageView.frame;
}


- (void)createUI{
    
    _mainScrollView = [[UIScrollView alloc] init];
    [self addSubview:_mainScrollView];
    _mainScrollView.frame = CGRectMake(0, 0, self.width, self.height);// frame中的size指UIScrollView的可视范围
//    _mainScrollView.delegate = self;
    _mainScrollView.backgroundColor = [UIColor clearColor];//注意，背景是clearcolor
    _mainScrollView.clipsToBounds = YES;
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.alwaysBounceVertical = YES;
    _mainScrollView.alwaysBounceHorizontal = YES;//这是为了左右滑时能够及时回调scrollViewDidScroll代理
    if (@available(iOS 11.0, *))//表示只在ios11以上的版本执行
    {
        _mainScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
        
    _mainScrollView.contentSize = self.imageView.frame.size;
    _mainScrollView.minimumZoomScale = 1.0;//最小缩放比例
    _mainScrollView.maximumZoomScale = 3.0;//最大缩放比例
    _mainScrollView.zoomScale = 1.0f;//当前缩放比例
    _mainScrollView.contentOffset = CGPointZero;//当前偏移
    
    
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
    _imageView.center = self.center;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.userInteractionEnabled = YES;
    
    [_mainScrollView addSubview:_imageView];
    _imageView.center = [self centerOfScrollViewContent:_mainScrollView];
}



/** 计算imageview的center，核心方法之一 */
- (CGPoint)centerOfScrollViewContent:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width) ? (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;//x偏移
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height) ? (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;//y偏移
    CGPoint actualCenter = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,scrollView.contentSize.height * 0.5 + offsetY);
    
    return actualCenter;
}
@end
