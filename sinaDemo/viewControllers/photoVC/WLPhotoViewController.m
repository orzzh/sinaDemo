//
//  WLPhotoViewController.m
//  sinaDemo
//
//  Created by WL on 2018/1/4.
//  Copyright https://github.com/orzzh All rights reserved.
//

#import "WLPhotoViewController.h"
#import "WLPhotoCollectionViewCell.h"
#import "WLPhotoViewController.h"
#import "PhotoVolumeModel.h"
#import "WLBrowseViewController.h"
#import "OneViewController.h"
#import "PhotoAlbumView.h"
#import "NextBtn.h"
#import "EditPhotoViewController.h"

#define BOTTOM_H 49

static NSString *CELL_PHOTO = @"CELL_PHOTO";

@interface WLPhotoViewController ()<
UICollectionViewDelegate,
UICollectionViewDataSource,
UINavigationControllerDelegate,
WLPhotoCollectionViewCellDelegate
>
//视图
@property (nonatomic ,strong)UIView *bottomView;
@property (nonatomic ,strong)UIButton *preViewBtn;
@property (nonatomic ,strong)UIButton *titleBtn;
@property (nonatomic ,strong)NextBtn *nextBtn;
@property (nonatomic ,strong)PhotoAlbumView *albumView;
//数据
@property (nonatomic,strong)NSMutableArray<PhotoAssetModel*> *selectPtos;
@property (nonatomic,strong)NSMutableDictionary *dataDic;//相册集 <PhotoVolumeModel*>

@end

@implementation WLPhotoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setupViews];
    [self checkAuthor];
}


//
- (void)checkDataWith:(PhotoVolumeModel *)model{
    for (NSString *title in _dataDic.allKeys) {
        if ([title isEqualToString:model.volumeTitle]) {
            NSArray *photoAry = [_dataDic objectForKey:title];
            _currueDataAry = photoAry;
            [self.colloectView reloadData];
            return;
        }
    }
    
    //未储存
    NSArray *photoAry = [NSArray arrayWithArray:model.photoAry];
    [_dataDic setObject:photoAry forKey:model.volumeTitle];
    _currueDataAry = [NSArray arrayWithArray: model.photoAry];
    [self.colloectView reloadData];
}


#pragma mark - button Action
//预览
- (void)preViewAct{
    if (self.selectPtos.count <=0) {return;}
    [self pushBrowseWithAry:_selectPtos isTranstion:NO starIndex:0];
}

//原图
- (void)highPicAct{
    NSLog(@"点击了原图");
}

- (void)cencel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)next{
    if (self.selectPtos.count <=0) {return;}
    
    //选择单张 进入编辑
    if (self.selectPtos.count == 1) {
        EditPhotoViewController *editVC = [[EditPhotoViewController alloc]init];
        editVC.model = self.selectPtos[0];
        self.navigationController.delegate = nil;
        [self.navigationController pushViewController:editVC animated:YES];
        
    }else{
        //进入发布
    }
}

- (void)titleAction{
    [self.albumView open];
}



#pragma mark - prive method
// 添加或者删除 选中图片
- (void)addOrRemoveWithModel:(PhotoAssetModel *)model{
    if (![_selectPtos containsObject:model] && model.isSelected) {
        [_selectPtos addObject:model];
    }
    if ([_selectPtos containsObject:model] && !model.isSelected) {
        [_selectPtos removeObject:model];
    }
    [self selectPtosChanage];
}

- (void)selectPtosChanage{
    if (self.selectPtos.count > 0) {
        _preViewBtn.selected = YES;
        _nextBtn.enabled = YES;
        [_nextBtn setTitle:[NSString stringWithFormat:@"下一步(%zd)",self.selectPtos.count] forState:UIControlStateNormal];
    }else{
        _preViewBtn.selected = NO;
        _nextBtn.enabled = NO;
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    }
    
}

// 照片浏览器跳转
- (void)pushBrowseWithAry:(NSArray *)photos isTranstion:(BOOL)isTranstion starIndex:(NSInteger)starIndex{
    WeakSelf;
    WLBrowseViewController *browseVC = [[WLBrowseViewController alloc]init];
    browseVC.photosAry = photos;
    browseVC.selectPhotosAry = _selectPtos;
    browseVC.starIndex = starIndex;
    browseVC.isPreView = !isTranstion;
    browseVC.selectBlock = ^(PhotoAssetModel *model) {
        model.isSelected = !model.isSelected;
        [weakSelf addOrRemoveWithModel:model];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshCellState" object:nil];
    };
    
    //是否实现转场动画
    self.navigationController.delegate = nil;
    if (isTranstion) {
        self.navigationController.delegate = self;
    }
    [self.navigationController pushViewController:browseVC animated:YES];
}

- (void)setupViews{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.colloectView];
    [self.view addSubview:self.bottomView];
    self.navigationItem.titleView = self.titleBtn;
    [self addNavigationItemWithTitles:@[@"取消"] isLeft:YES target:self action:@selector(cencel) tags:@[@"1"] colors:@[[UIColor grayColor]]];
    _nextBtn = [[NextBtn alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    [_nextBtn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_nextBtn];
    [self selectPtosChanage];
}

//检查授权
- (void)checkAuthor{
    [WLPohotoManager requestAuthorizationHandler:^(BOOL isAuthorized) {
        if (isAuthorized) {
            [self setupData];
        }else{
            NSLog(@"您还未授权");
        }
    }];
}

// 初始数据
- (void)setupData{
    _dataDic = [[NSMutableDictionary alloc]init];
    _currueDataAry = [[NSMutableArray alloc]init];
    _selectPtos = [[NSMutableArray alloc]init];
    
    //获取默认显示相册内容
    PhotoVolumeModel *model = [PhotoVolumeModel getCameraRollVolume];
    NSArray *photoAry = [NSArray arrayWithArray:model.photoAry];
    
    //保存相册数组
    [_dataDic setObject:photoAry forKey:model.volumeTitle];
    
    _currueDataAry = photoAry;
    [self.colloectView reloadData];
}



#pragma  mark - WLPhotoCollectionViewCellDelegate
- (void)didSelectStateChanageAtIndex:(NSInteger)index{
    PhotoAssetModel *model = [_currueDataAry objectAtIndex:index];
    model.isSelected = !model.isSelected;
    [self addOrRemoveWithModel:model];
}

#pragma mark - UICollectionViewDelegate/UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _currueDataAry.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WLPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_PHOTO forIndexPath:indexPath];
    cell.delegate = self;
    PhotoAssetModel *model = [_currueDataAry objectAtIndex:indexPath.row];
    model.index_Row = indexPath.row;
    [cell setModel:_currueDataAry[indexPath.row]];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"index %zd",indexPath.row);
    NSLog(@"进入图片浏览");
    _selectIndex = indexPath;
    PhotoAssetModel *model = [_currueDataAry objectAtIndex:indexPath.row];
    [self pushBrowseWithAry:_currueDataAry isTranstion:YES starIndex:model.index_Row];
}

#pragma mark - UIViewControllerTransitioningDelegate 转场

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC {
    if (operation == UINavigationControllerOperationPush) {
        return [WLTranstionManager managerWithtype:WLTranstionTypePhoto model:WLTranstionModePush];
    }
    return [WLTranstionManager managerWithtype:WLTranstionTypePhoto model:WLTranstionModePop];
}






#pragma mark - lazyload

- (UICollectionView *)colloectView{
    if (!_colloectView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake((SCREEN_WIDTH-3)/4,(SCREEN_WIDTH-3)/4);
        layout.minimumLineSpacing = 1;
        layout.minimumInteritemSpacing = 1;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _colloectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, IPX_NV, SCREEN_WIDTH, SCREENH_HEIGHT-40-IPX-IPX_NV) collectionViewLayout:layout];
        [_colloectView registerClass:[WLPhotoCollectionViewCell class] forCellWithReuseIdentifier:CELL_PHOTO];
        _colloectView.delegate = self;
        _colloectView.dataSource = self;
        _colloectView.backgroundColor =[UIColor whiteColor];
        
    }
    return _colloectView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENH_HEIGHT-40-IPX, SCREEN_WIDTH, 40)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        [_bottomView setBorderWithTop:YES left:NO bottom:NO right:NO borderColor:COLOR_GR(0.2) borderWidth:1];
        
        _preViewBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        [_preViewBtn setTitle:@"预览" forState:UIControlStateNormal];
        [_preViewBtn setTitleColor:COLOR_GR(0.3) forState:UIControlStateNormal];
        [_preViewBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        _preViewBtn.frame = CGRectMake(10, 0, 50, 40);
        _preViewBtn.titleLabel.font = FONTSIZE(14);
        [_preViewBtn addTarget:self action:@selector(preViewAct) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:_preViewBtn];
        
        UIButton *bigBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        [bigBtn setTitle:@"原图" forState:UIControlStateNormal];
        [bigBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        bigBtn.frame = CGRectMake(60, 0, 70, 40);
        bigBtn.titleLabel.font = FONTSIZE(13);
        [bigBtn addTarget:self action:@selector(highPicAct) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:bigBtn];
    }
    return _bottomView;
}

- (UIButton *)titleBtn{
    if (!_titleBtn) {
        _titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _titleBtn.frame = CGRectMake(0, 0, 100, 44);
        [_titleBtn setTitle:@"相机胶卷" forState: UIControlStateNormal];
        [_titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _titleBtn.titleLabel.font = FONTSIZE(15);
        [_titleBtn sizeToFit];
        [_titleBtn addTarget:self action:@selector(titleAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _titleBtn;
}

- (PhotoAlbumView *)albumView{
    if (!_albumView) {
        _albumView = [[PhotoAlbumView alloc]initWithFrame:CGRectMake(0, self.colloectView.originY, SCREEN_WIDTH, SCREENH_HEIGHT-IPX_NV)];
        WeakSelf;
        _albumView.block = ^(PhotoVolumeModel *volumeModel) {
            [weakSelf checkDataWith:volumeModel];
        };
        _albumView.hidden = YES;
        [self.view addSubview:_albumView];
    }
    return _albumView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
