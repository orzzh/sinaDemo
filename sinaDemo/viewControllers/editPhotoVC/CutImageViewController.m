//
//  CutImageViewController.m
//  sinaDemo
//
//  Created by wl on 2018/1/12.
//  Copyright https://github.com/orzzh All rights reserved.
//

#import "CutImageViewController.h"
#import "UIImage+SubImage.h"


@interface CutImageViewController ()<UIScrollViewDelegate>
{
    UIView *coverView;
}
@end

@implementation CutImageViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
 
    [self showEdit];
    
    self.imgView.layer.masksToBounds = NO;
    self.scView.layer.masksToBounds = NO;
    coverView = [[UIView alloc]initWithFrame:self.toolBgView.frame];
    coverView.backgroundColor = [UIColor whiteColor];
    coverView.alpha = 0.9;
    [self.view addSubview:coverView];
    [self.view addLine];
}




#pragma mark - 进入裁剪模式 显示裁剪菜单
- (void)showEdit{
    CGFloat img_w = self.imgView.image.size.width;
    CGFloat img_h = self.imgView.image.size.height;
    CGFloat w = img_h > img_w ? SCREEN_WIDTH : SCREEN_WIDTH * img_w / img_h;
    CGFloat h = img_h > img_w ? img_h * w / img_w : SCREEN_WIDTH;
    self.scView.contentSize = CGSizeMake(w, h);
    
    //显示剪切菜单
    self.cutView.hidden = NO;
    self.cutView.transform = CGAffineTransformTranslate(self.cutView.transform, 0, self.cutView.height+IPX);
    
    [UIView animateWithDuration:0.3 animations:^{
        self.cutView.transform = CGAffineTransformIdentity;
        self.imgView.frame = CGRectMake(0, 0, w, h);
    }];
}

#pragma mark - 取消编辑

- (void)cutCencel{
    [self.view.layer.sublayers.lastObject removeFromSuperlayer];
    [coverView removeFromSuperview];
    //图像恢复 菜单隐藏 工具栏显示
    self.scView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH);
    [UIView animateWithDuration:0.3 animations:^{
        self.imgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH);
        self.cutView.transform = CGAffineTransformTranslate(self.cutView.transform, 0, self.cutView.height+IPX);
    }completion:^(BOOL finished) {
        self.cutView.transform = CGAffineTransformIdentity;
        [self.navigationController popViewControllerAnimated:NO];
    }];
}

#pragma mark - 完成编辑

- (void)cutNext{
    CGPoint p       = self.scView.contentOffset;
    CGFloat img_w   = self.imgView.image.size.width;
    CGFloat img_h   = self.imgView.image.size.height;
    CGFloat scale_y = p.y/self.imgView.frame.size.height;
    CGFloat scale_x = p.x/self.imgView.frame.size.width;
    CGFloat cut_w   = img_h > img_w ? self.imgView.image.size.width :self.imgView.image.size.height;
    self.imgView.image = [self.imgView.image subImageWithRect:CGRectMake(img_w*scale_x, img_h*scale_y, cut_w, cut_w)];
    self.imgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH);
    
    //返回图片
    if (self.block) {
        self.block(self.imgView.image);
    }
    
    //返回动画
    [self cutCencel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"裁剪";
    self.navigationItem.hidesBackButton =YES;
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
