//
//  toolScrollView.m
//  sinaDemo
//
//  Created by wl on 2018/1/10.
//  Copyright https://github.com/orzzh All rights reserved.
//

#import "toolScrollView.h"
#import "ToolCollectionViewCell.h"

static NSString *cellID = @"123";

@interface toolScrollView()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSInteger _type; // 0 滤镜  1纸贴。 2 设置
}
@property (nonatomic,strong)UICollectionView *cView;

@end
@implementation toolScrollView

- (instancetype)initWithFrame:(CGRect)frame type:(NSInteger)type{
    self = [super initWithFrame:frame];
    if (self) {
        _type = type;
        [self addSubview:self.cView];
    }
    return self;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_type == 2) {
        return 3;
    }
    return 5;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ToolCollectionViewCell *cell = (ToolCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:_pasteAry[indexPath.row]];
    
    //滤镜
    if (_type == 1) {
        cell.titleView.text = _filteAry[indexPath.row];
        if (indexPath.row == 0) {
            [cell selected];
        }
    }
    
    //设置
    if (_type == 2) {
        cell.imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH/10, SCREEN_WIDTH/10);
        cell.imageView.center = CGPointMake(cell.width/2, cell.height/2);
        cell.borderLayer.hidden = NO;
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_type == 1) {
        ToolCollectionViewCell *cell = (ToolCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"deful" object:nil];
        [cell selected];
    }
    if (self.seletedBlock) {
        self.seletedBlock(indexPath.row);
    }

}


- (void)setHidden:(BOOL)hidden{
    if(hidden && (_type == 0 || _type == 1)){self.cView.contentOffset = CGPointMake(0, 0);}
    [super setHidden:hidden];
}

- (UICollectionView *)cView{
    if (!_cView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = _type == 2 ? 1 : 5;
        layout.minimumInteritemSpacing = _type == 2 ? 0 : 5;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.itemSize = _type == 2 ? CGSizeMake(SCREEN_WIDTH/3, SCREEN_WIDTH/3) : CGSizeMake(SCREEN_WIDTH/5, SCREEN_WIDTH/4);
        _cView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, self.height/2-SCREEN_WIDTH/8, SCREEN_WIDTH, SCREEN_WIDTH/4) collectionViewLayout:layout];
        _cView.backgroundColor = [UIColor whiteColor];
        _cView.delegate = self;
        _cView.dataSource = self;
        [_cView registerClass:[ToolCollectionViewCell class] forCellWithReuseIdentifier:cellID];
        _cView.scrollEnabled = _type == 2 ? NO : YES;
        _cView.showsHorizontalScrollIndicator = NO;
    }
    return _cView;
}

@end
