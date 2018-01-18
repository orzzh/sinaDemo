//
//  MosaicViewController.m
//  sinaDemo
//
//  Created by wl on 2018/1/12.
//  Copyright https://github.com/orzzh All rights reserved.
//

#import "MosaicViewController.h"
#import "MosaicView.h"
#import "UIImage+Mosiac.h"
#import "UIImage+SubImage.h"

@interface MosaicViewController ()
{
    NSMutableArray *btnAry;
}
@property (nonatomic,strong)MosaicView *mosaicView;
@property (nonatomic,strong)UIView *PanView;

@end

@implementation MosaicViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self showEdit];
}


#pragma mark - 取消编辑

- (void)cutCencel{
    //隐藏马赛克画板
    self.mosaicView.hidden = YES;
    self.imgView.hidden = NO;
    
    self.scView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH);
    [UIView animateWithDuration:0.3 animations:^{
        self.scView.frame = CGRectMake(0, self.scView.originY, SCREEN_WIDTH, SCREEN_WIDTH);
        self.imgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH);
        self.cutView.transform = CGAffineTransformTranslate(self.cutView.transform, 0, self.cutView.height+IPX);
    } completion:^(BOOL finished) {
        [self.navigationController popViewControllerAnimated:NO];
    }];
}

#pragma mark - 完成编辑

- (void)cutNext{
    self.imgView.image = [UIImage imageFromView:self.mosaicView];
    
    //返回图片
    if (self.block) {
        self.block(self.imgView.image);
    }
    
    //返回动画
    [self cutCencel];
}

- (void)selected:(UIButton *)sender{
    if (sender.selected) {
        sender.selected = NO;
        [self setBorder:sender];
        
        //可以滚动
        self.scView.scrollEnabled = YES;
        self.mosaicView.isOpen = NO;
        return;
    }

    for (UIButton *brn in btnAry) {
        brn.selected = NO;
        brn.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    sender.selected = YES;
    self.scView.scrollEnabled = NO;
    [self selectBorder:sender];
    
    //可以涂马赛克
    self.mosaicView.isOpen = YES;
    self.mosaicView.lineWidth = sender.width-2;
}

- (void)selectBorder:(UIButton *)btn{
    btn.layer.borderWidth = 2;
    btn.layer.borderColor = [UIColor orangeColor].CGColor;
}

- (void)removePath{
    [self.mosaicView removePath];
}

#pragma mark - 动画

- (void)showEdit{
    CGFloat pad = self.PanView.originY-self.scView.originY;
    CGFloat img_w = self.imgView.image.size.width;
    CGFloat img_h = self.imgView.image.size.height;
    CGFloat w = img_h > img_w ? SCREEN_WIDTH : SCREEN_WIDTH * img_w / img_h;
    CGFloat h = img_h > img_w ? img_h * w / img_w : SCREEN_WIDTH;
    self.scView.contentSize = CGSizeMake(w, h);

    //显示剪切菜单
    self.toolBgView.hidden = YES;
    self.cutView.hidden = NO;
    self.cutView.transform = CGAffineTransformTranslate(self.cutView.transform, 0, self.cutView.height+IPX);
   
    CGFloat img_top = w>=h ? (pad-h)/2 : 0 ;
    [UIView animateWithDuration:0.3 animations:^{
        self.scView.frame = CGRectMake(0, self.scView.originY, SCREEN_WIDTH, pad);
        self.imgView.frame = CGRectMake(0, img_top, w, h);
        self.cutView.transform = CGAffineTransformIdentity;
    }completion:^(BOOL finished) {
        self.imgView.hidden = YES;
        self.mosaicView = [[MosaicView alloc]initWithFrame:self.imgView.frame];
        self.mosaicView.surfaceImage = self.imgView.image;
        self.mosaicView.image= [self.imgView.image transToMosaicWithblockLevel:15];
        [self.scView addSubview:_mosaicView];

        //显示提示
        [ToastManage showCenterToastWith:@"选中画笔后不可滚动图片，取消选中可滑动图片"];
    }];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"马赛克";
    self.navigationItem.hidesBackButton =YES;
    
}


- (MosaicView *)mosaicView{
    if (!_mosaicView) {
        _mosaicView = [[MosaicView alloc]init];
        [self.scView addSubview:_mosaicView];
    }
    return _mosaicView;
}

- (UIView *)PanView{
    if (!_PanView) {
        _PanView = [[UIView alloc]initWithFrame:CGRectMake(0, self.cutView.originY-50, SCREEN_WIDTH, 50)];
        _PanView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_PanView];
        
        UIImageView *mosic = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 30, 30)];
        mosic.image = [UIImage imageNamed:@"马赛克"];
        [_PanView addSubview:mosic];
        
        UIButton *cel = [UIButton buttonWithType:UIButtonTypeCustom];
        cel.frame = CGRectMake(SCREEN_WIDTH-50, 10, 30, 30);
        [cel setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
        [cel addTarget:self action:@selector(removePath) forControlEvents:UIControlEventTouchUpInside];
        [_PanView addSubview:cel];
        
        UIButton *one = [UIButton buttonWithType:UIButtonTypeCustom];
        one.layer.cornerRadius=6;
        one.frame = CGRectMake(0, 0, 12, 12);
        one.center = CGPointMake(SCREEN_WIDTH/2-40, 25);
        [one addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
        [_PanView addSubview:one];
        
        UIButton *two = [UIButton buttonWithType:UIButtonTypeCustom];
        two.layer.cornerRadius=17/2;
        two.frame = CGRectMake(0, 0, 17, 17);
        two.center = CGPointMake(SCREEN_WIDTH/2, 25);
        [two addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
        [_PanView addSubview:two];
        
        UIButton *three = [UIButton buttonWithType:UIButtonTypeCustom];
        three.layer.cornerRadius=11;
        three.frame = CGRectMake(0, 0, 22, 22);
        three.center = CGPointMake(SCREEN_WIDTH/2+40, 25);
        [three addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
        [_PanView addSubview:three];
        [self setBorder:one];
        [self setBorder:two];
        [self setBorder:three];
        
        btnAry = [[NSMutableArray alloc]init];
        [btnAry addObject:one];
        [btnAry addObject:two];
        [btnAry addObject:three];
    }
    return _PanView;
}

- (void)setBorder:(UIButton *)btn{
    btn.layer.borderWidth = 2;
    btn.selected = NO;
    btn.backgroundColor = [UIColor blackColor];
    btn.layer.borderColor = [UIColor whiteColor].CGColor;
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
