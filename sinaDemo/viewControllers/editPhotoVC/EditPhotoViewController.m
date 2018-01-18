//
//  EditPhotoViewController.m
//  sinaDemo
//
//  Created by wl on 2018/1/10.
//  Copyright https://github.com/orzzh All rights reserved.
//

#import "EditPhotoViewController.h"
#import "toolScrollView.h"
#import "wlPohotoManager.h"
#import "UIImage+Rotate.h"
#import "UIImage+SubImage.h"
#import "PasteView.h"
#import "NextBtn.h"
#import "UIView+GradientBgColor.h"
#import "CutImageViewController.h"
#import "MosaicViewController.h"

@interface EditPhotoViewController ()
{
    NSInteger _currToolIndex;
    NSArray *pasteAry;
    NSArray *filterAry;
    NSArray *editAry;
}
@property (nonatomic,strong)UIImageView *pasteView;         //纸贴层

@property (nonatomic,strong)NSMutableArray *scToolAry;      //菜单item
@property (nonatomic,strong)NSMutableDictionary *pasteDic;  //贴纸数组

@end

@implementation EditPhotoViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _currToolIndex = 0;
    _pasteDic = [[NSMutableDictionary alloc]init];
    _scToolAry = [[NSMutableArray alloc]init];
    pasteAry  = @[@"tuzi",@"pingan",@"ji",@"2018",@"185"];
    filterAry = @[@"tuzi",@"pingan",@"2018",@"185",@"185"];
    editAry   = @[@"旋转",@"剪切",@"马赛克"];

    [self createUI];
}

#pragma  mark - Action
- (void)nextAct{
    NSLog(@"确定");
    for (PasteView *v in _pasteDic.allValues) { // 合并图层 返回
        [v hideEdit];                           // 隐藏贴纸编辑边框
    }
    
    //是否创建 贴纸盒子
    if (_pasteView) {
        _pasteView.image = self.imgView.image;         //刷新盒子内图片
    }else{
        [self creatBoxWithImage:self.imgView.image];   //未创建先创建 盒子
    }
    UIImage *img = [UIImage imageFromView:_pasteView]; //转image
    [WLPohotoManager saveWithImage:img];               //保存到相册
}


#pragma mark - toolBarView block 切换操作界面
- (void)chanageType:(NSInteger)num{
    if (_currToolIndex == num) {return;}
    
    for (toolScrollView *scTool in _scToolAry) {
        scTool.hidden = YES;
    }
    _currToolIndex = num;
    toolScrollView *scTool = [_scToolAry objectAtIndex:num];
    scTool.hidden = NO;
    //工具
    _pasteView.hidden = num != 0 ? YES:NO;
    //切回
    if(num == 0){[self creatBoxWithImage:self.imgView.image];}
}

#pragma mark - toolScrollView block 切换操作界面
- (void)editImageAtIndex:(NSInteger)index{
    switch (_currToolIndex) {
        case 0:
            NSLog(@"贴纸 %zd",index);
            [self addPasteWithIndex:index];
            break;
        case 1:{
            NSLog(@"滤镜 %zd",index);
            }break;
        case 2:{
            NSLog(@"设置 %zd",index);
            if(index == 0){[self rotate];}
            if(index == 1){[self cut];}
            if(index == 2){[self mosaic];}
        }break;
        default:
            break;
    }
}


#pragma mark - 添加贴纸

- (void)addPasteWithIndex:(NSInteger)index{
    PasteView *im = [[PasteView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    im.tag = _pasteDic.count;
    WeakSelf;
    im.deleteBlock = ^(NSInteger index) {
        [weakSelf.pasteDic removeObjectForKey:[NSString stringWithFormat:@"%zd",index]];
    };
    im.center = CGPointMake(_pasteView.width/2, _pasteView.height/2);
    im.pasteImage.image = [UIImage imageNamed:pasteAry[index]];
    [_pasteView addSubview:im];
    [_pasteDic setObject:im forKey:[NSString stringWithFormat:@"%zd",_pasteDic.count]];
}

#pragma mark - 编辑菜单
//********************* 旋转 *********************
- (void)rotate{
    self.imgView.image = [self.imgView.image rotate:UIImageOrientationRight];
}

//********************* 裁剪 *********************
- (void)cut{
    WeakSelf;
    CutImageViewController *cutVC = [[CutImageViewController alloc]init];
    cutVC.imgView.image = self.imgView.image;
    cutVC.block = ^(UIImage *img) {
        weakSelf.imgView.image = img;
    };
    [self.navigationController pushViewController:cutVC animated:NO];
}
//********************* 马赛克 *********************
- (void)mosaic{
    WeakSelf;
    MosaicViewController *cutVC = [[MosaicViewController alloc]init];
    cutVC.imgView.image = self.imgView.image;
    cutVC.block = ^(UIImage *img) {
        weakSelf.imgView.image = img;
    };
    [self.navigationController pushViewController:cutVC animated:NO];
}

//添加纸贴层
- (void)creatBoxWithImage:(UIImage *)image{
    CGFloat scale = image.size.width/image.size.height;
    
    CGFloat w = scale>1 ? SCREEN_WIDTH : SCREEN_WIDTH*scale;
    CGFloat h = scale>1 ? SCREEN_WIDTH/scale : SCREEN_WIDTH;
    
    //已创建 仅刷新
    if (_pasteView) {
        _pasteView.frame = CGRectMake(0, 0, w, h);
        _pasteView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_WIDTH/2+IPX_NV);
        _pasteView.image = image;
        return;
    }
    
    //创建
    _pasteView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, w*3, h)];
    _pasteView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_WIDTH/2+IPX_NV);
    _pasteView.layer.masksToBounds = YES;
    _pasteView.userInteractionEnabled = YES;
    _pasteView.image = image;
    _pasteView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_pasteView];
}


- (void)createUI{
    
    [self addNavigationItemWithTitles:@[@"返回"] isLeft:YES target:self action:@selector(popAct) tags:@[@"1"] colors:@[[UIColor grayColor]]];
    
    NextBtn *_nextBtn = [[NextBtn alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    [_nextBtn setTitle:@"确定" forState:UIControlStateNormal];
    _nextBtn.selected = YES;
    [_nextBtn addTarget:self action:@selector(nextAct) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_nextBtn];
    
    //加载图片
    if (self.imgCamear) {                     //图片路径：拍照获取
        self.imgView.image = self.imgCamear;
        [self creatBoxWithImage:self.imgCamear];
    }else{
        WeakSelf;                             //图片路径：相册获取
        [[WLPohotoManager sharedInstance] getImageLowQualityForAsset:self.model.asset targetSize:CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH/self.model.asset.pixelWidth*SCREEN_WIDTH) resultHandler:^(UIImage *result, NSDictionary *info) {
            weakSelf.imgView.image = result;
            [weakSelf creatBoxWithImage:result];
        }];
    }

    
    //创建添加工具栏
    for (int i = 0; i<3; i++) {
        CGFloat height = SCREENH_HEIGHT-(IPX_NV+SCREEN_WIDTH)-IPX-45;
        NSInteger type = i;
        toolScrollView *scTool = [[toolScrollView alloc]initWithFrame:CGRectMake(0, IPX_NV+SCREEN_WIDTH, SCREEN_WIDTH, height) type:type];
        WeakSelf;
        scTool.seletedBlock = ^(NSInteger index) {
            [weakSelf editImageAtIndex:index];
        };
        scTool.tag = i;
        scTool.hidden = YES;
        [_scToolAry addObject:scTool];
        [self.view addSubview:scTool];
        
        if (i == 0) {
            scTool.hidden = NO;
            scTool.pasteAry = pasteAry;
        }
        if (i == 1) {
            scTool.filteAry = filterAry;
        }
        if (i == 2) {
            scTool.pasteAry = editAry;
        }
    }
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
