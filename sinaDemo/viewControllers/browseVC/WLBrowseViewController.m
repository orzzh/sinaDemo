//
//  wlBrowseViewController.m
//  sinaDemo
//
//  Created by wl on 2018/1/5.
//  Copyright https://github.com/orzzh All rights reserved.
//

#import "WLBrowseViewController.h"
#import "WLBrowseViewCell.h"
#import "SelectBox.h"
#import "NextBtn.h"
#import "EditPhotoViewController.h"

static NSString *cellID = @"image";

@interface WLBrowseViewController ()<
WLScrollViewDelegate
>
{
    NSInteger _currIndex;
    SelectBox *selectBtn;
    UILabel *titleLbl;
    NextBtn *_nextBtn;
}
@end

@implementation WLBrowseViewController
@synthesize isPreView = _isPreView;
@synthesize starIndex = _starIndex;

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self checkSelectState];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}

#pragma mark - action

- (void)nextAct{
    if (self.selectPhotosAry.count <=0) {return;}
    NSLog(@"下一步");
    if (self.selectPhotosAry.count == 1) {
        //进入编辑
        EditPhotoViewController *editVC = [[EditPhotoViewController alloc]init];
        editVC.model = self.selectPhotosAry[0];
        self.navigationController.delegate = nil;
        [self.navigationController pushViewController:editVC animated:YES];

    }else{
        //进入发布
    }
}

- (void)selectAct:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (self.selectBlock) {
        self.selectBlock(self.photosAry[_currIndex]);
    }
    [self checkSubNumber];
}

//检查当前照片选中状态
- (void)checkSelectState{
    PhotoAssetModel *model = self.photosAry[_currIndex];
    selectBtn.selected = model.isSelected;
    
    titleLbl.text = [NSString stringWithFormat:@"%zd/%zd",_currIndex+1,self.photosAry.count];
    [titleLbl sizeToFit];

    [self checkSubNumber];
}

//计算已选择总和
- (void)checkSubNumber{
    if (self.selectPhotosAry.count>0) {
        _nextBtn.enabled = YES;
        [_nextBtn setTitle:[NSString stringWithFormat:@"下一步(%zd)",self.selectPhotosAry.count] forState:UIControlStateNormal];
    }else{
        _nextBtn.enabled = NO;
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    }
}

#pragma mark - wlScrollViewDelegate

- (NSInteger)numOfContentViewScrollView:(WLScrollView *)scrollView{
    return self.photosAry.count;
}
- (WLSubView *)scrollView:(WLScrollView *)scrollView subViewFrame:(CGRect)frame cellAtIndex:(NSInteger)index{
    
    WLBrowseViewCell *sub = (WLBrowseViewCell *)[scrollView dequeueReuseCellWithIdentifier:cellID];
    if (!sub) {
        sub = [[WLBrowseViewCell alloc]initWithFrame:frame Identifier:cellID];
    }
    PhotoAssetModel *model = [self.photosAry objectAtIndex:index];
    [sub setModel:model frame:frame];
    return sub;
}
- (void)scrollView:(WLScrollView *)scrollView didSelectedAtIndex:(NSInteger)index{
    NSLog(@"点击 index %zd",index);
}
- (void)scrollView:(WLScrollView *)scrollView didCurrentCellAtIndex:(NSInteger)index{
    NSLog(@"现在显示的 index %zd",index);
    _currIndex = index;
    [self checkSelectState];
}





- (void)createUI{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor grayColor];
    [self addNavigationItemWithTitles:@[@"返回"] isLeft:YES target:self action:@selector(popAct) tags:@[@"1"] colors:@[[UIColor grayColor]]];
    
    titleLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLbl.font = FONTSIZE(15);
    titleLbl.textColor = [UIColor blackColor];
    self.navigationItem.titleView = titleLbl;
    
    _nextBtn = [[NextBtn alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    [_nextBtn addTarget:self action:@selector(nextAct) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_nextBtn];
    [self checkSelectState];
}

- (void)setIsPreView:(BOOL)isPreView{
    _isPreView = isPreView;
    self.wlScrView.isEnableMargin = isPreView;
}

- (void)setStarIndex:(NSInteger)starIndex{
    _starIndex = starIndex;
    _currIndex = starIndex;
}

- (WLScrollView *)wlScrView{
    if (!_wlScrView) {
        [_wlScrView removeFromSuperview];
        _wlScrView = nil;
        _wlScrView = [[WLScrollView alloc]initWithFrame:CGRectMake(0, IPX_NV, SCREEN_WIDTH, SCREENH_HEIGHT-IPX_NV-IPX)];
        _wlScrView.layer.masksToBounds = YES;
        _wlScrView.delegate = self;
        _wlScrView.isAnimation = NO;
        _wlScrView.scale = 1;
        _wlScrView.marginX = 0;
        [_wlScrView setIndex:self.starIndex];
        [_wlScrView starRender];
        [self.view addSubview:self.wlScrView];

        selectBtn = [[SelectBox alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-50, 20+IPX_NV, 30, 30)];
        [selectBtn addTarget:self action:@selector(selectAct:) forControlEvents:UIControlEventTouchUpInside];
        [selectBtn setSelectBackboundColor:[UIColor whiteColor] dedul:[UIColor grayColor]];
        selectBtn.selected = NO;
        [self.view addSubview:selectBtn];
    }
    return _wlScrView;
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
