//
//  TakePhotoViewController.m
//  sinaDemo
//
//  Created by wl on 2018/1/16.
//  Copyright © 2018年 https://github.com/orzzh. All rights reserved.
//

#import "TakePhotoViewController.h"
#import "TakeVideoViewController.h"
#import "EditPhotoViewController.h"
#import "UIImage+SubImage.h"
#import "UIImage+Rotate.h"

@interface TakePhotoViewController ()

@property (nonatomic,strong)UIImageView *imageView;

@end

@implementation TakePhotoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tip.text=@"左滑切换";

    //左滑手势
    UISwipeGestureRecognizer * ges= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(goCamera)];
    [ges setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.view addGestureRecognizer:ges];
    
    [self.takeBtn addTarget:self action:@selector(takeAction) forControlEvents:UIControlEventTouchUpInside];
}


- (void)createCamear{
//    初始化拍照
    [self createPhotoCamear:YES];
}

#pragma mark - 去拍视频

- (void)goCamera{
    WeakSelf;
    TakeVideoViewController *v = [[TakeVideoViewController alloc]init];
    v.block = ^(BOOL isPostC) {
        [weakSelf checkCamear:isPostC];
    };
    v.isPostCamear = self.isPostCamear;
    [self.navigationController pushViewController:v animated:NO];
}

#pragma mark - 检查是否切换相机

- (void)checkCamear:(BOOL)isPostC{
    if (isPostC != self.isPostCamear) {
        [self chanage];
    }
    self.isPostCamear = isPostC;
}

#pragma mark - 拍照

- (void)takeAction{
    self.outputConnect = [self.ImageOutPut connectionWithMediaType:AVMediaTypeVideo];

    if(!self.outputConnect){NSLog(@"failed!");return;}
    
    WeakSelf;
    [self.ImageOutPut captureStillImageAsynchronouslyFromConnection:self.outputConnect completionHandler:^(CMSampleBufferRef  _Nullable imageDataSampleBuffer, NSError * _Nullable error) {
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        [weakSelf stopRun];
        [weakSelf pushEditVC:[UIImage imageWithData:imageData]];
    }];
}

#pragma mark - 进入编辑相片页面

- (void)pushEditVC:(UIImage *)image{
    image = [image subImageWithRect:CGRectMake(0, 0, image.size.width, image.size.width)];
    EditPhotoViewController *editVC = [[EditPhotoViewController alloc]init];
    editVC.imgCamear = [image rotate:UIImageOrientationRight];
    [self.navigationController pushViewController:editVC animated:NO];
}


- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:self.centerView.frame];
        _imageView.contentMode = UIViewContentModeScaleToFill;
        [self.view addSubview:_imageView];
    }
    return _imageView;
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
