//
//  VideoBaseViewController.m
//  sinaDemo
//
//  Created by wl on 2018/1/16.
//  Copyright © 2018年 https://github.com/orzzh. All rights reserved.
//

#import "VideoBaseViewController.h"

@interface VideoBaseViewController ()
{
    UIView *_bg;
    UIView *whiteView;
}
@end

@implementation VideoBaseViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self stopRun];
    whiteView.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    whiteView.hidden = YES;
    [self addMaskLayerIsOpen:YES];
    [self starRun];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"拍摄";
    _isPostCamear = YES;
    
    [self createUI];
    if ([self canUserCamear]) {
        [self createCamear];
    }
}

#pragma mark - 子类重写
- (void)createCamear{
    
}

- (void)createPhotoCamear:(BOOL)isPhoto{
    if (isPhoto) {
        [self createPhotoCamear];
    }else{
        [self createVideoCamear];
    }
}

#pragma mark - 初始化拍照
- (void)createPhotoCamear{
    _videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    _deviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:_videoDevice error:nil];
    _ImageOutPut = [[AVCaptureStillImageOutput alloc]init];

    if ([self.session canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
        [self.session setSessionPreset:AVCaptureSessionPreset1280x720];
    }
    if ([self.session canAddInput:_deviceInput]) {
        [self.session addInput:_deviceInput];
    }
    if ([self.session canAddOutput:_ImageOutPut]) {
        [self.session addOutput:_ImageOutPut];
    }
    if ([_videoDevice lockForConfiguration:nil]) {
        if ([_videoDevice isFlashModeSupported:AVCaptureFlashModeAuto]) {
            [_videoDevice setFlashMode:AVCaptureFlashModeOff];
        }
        //自动白平衡
        if ([_videoDevice isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
            [_videoDevice setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
        }
        [_videoDevice unlockForConfiguration];
    }
    [self addPreviewLayer];
}

#pragma mark - 初始化拍视频
- (void)createVideoCamear{
    _videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];//摄像头设备
    _voiceDecice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];//音频设备
    _deviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:_videoDevice error:nil];//添加输入设备
    AVCaptureDeviceInput *audioInput = [[AVCaptureDeviceInput alloc] initWithDevice:_voiceDecice error:nil];
    _videoOutput = [[AVCaptureMovieFileOutput alloc]init];//输出设备
    
    //输入设备添加会话中
    if ([self.session canAddInput:_deviceInput]) {
        [self.session addInput:_deviceInput];
        [self.session addInput:audioInput];
        _outputConnect = [_videoOutput connectionWithMediaType:AVMediaTypeVideo];
        if ([_outputConnect isVideoStabilizationSupported]) {
            _outputConnect.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
        }
    }
    
    if ([self.session canAddOutput:_videoOutput]) {//输出设备添加会话中
        [self.session addOutput:_videoOutput];
    }
    
    [self addPreviewLayer];
}

- (void)addPreviewLayer{ // 添加显示layer
    //图像layer层
    _previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
    _previewLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT);
    _previewLayer.videoGravity = AVLayerVideoGravityResize;
    [self.centerView.layer addSublayer:_previewLayer];
    self.centerView.layer.masksToBounds = YES;
    
    //开始捕捉
    [self starRun];
}

#pragma mark - 检查相机权限

- (BOOL)canUserCamear{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied) {
        NSLog(@"没打开权限");
        return NO;
    }
    else{
        return YES;
    }
    return YES;
}

#pragma  mark - 切换摄像头

- (void)chanage{
    NSUInteger cameraCount = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
    if (cameraCount > 1) {
        NSError *error;
        CATransition *animation = [CATransition animation];
        animation.duration = .5f;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.type = @"oglFlip";
        AVCaptureDevice *newCamera = nil;
        AVCaptureDeviceInput *newInput = nil;
        AVCaptureDevicePosition position = [[self.deviceInput device] position];
        if (position == AVCaptureDevicePositionFront){
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
            animation.subtype = kCATransitionFromLeft;
        }
        else {
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
            animation.subtype = kCATransitionFromRight;
        }
        
        newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
        [self.previewLayer addAnimation:animation forKey:nil];
        if (newInput != nil) {
            [self.session beginConfiguration];
            [self.session removeInput:self.deviceInput];
            if ([self.session canAddInput:newInput]) {
                [self.session addInput:newInput];
                self.deviceInput = newInput;
                
            } else {
                [self.session addInput:self.deviceInput];
            }
            
            [self.session commitConfiguration];
            
        } else if (error) {
            NSLog(@"toggle carema failed, error = %@", error);
        }
    }
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices )
        if ( device.position == position ) return device;
    return nil;
}

#pragma mark - Action

- (void)chageMode:(UIButton *)sender{
    if (sender.tag == 3) {//闪光灯
        NSLog(@"点击了闪光灯");
        return;
    }
    NSLog(@"点击了翻转");
    //翻转摄像头
    [self chanage];
    self.isPostCamear = !self.isPostCamear;
}

- (void)dismis{
    //结束动画
    [self stopRun];
    [self addMaskLayerIsOpen:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void)stopRun{ // 停止捕捉屏幕
    if ([self.session isRunning]) {[self.session stopRunning];}
}
- (void)starRun{ // 开始捕捉屏幕
    if (![self.session isRunning]) {[self.session startRunning];}
}

#pragma mark - UI

- (void)createUI{
    //导航栏按钮
    [self addNavigationItemWithTitles:@[@"X"] isLeft:YES target:self action:@selector(dismis) tags:@[@"1"] colors:@[[UIColor grayColor],[UIColor grayColor]]];
//    [self addNavigationItemWithTitles:@[@"翻转",@"闪光"] isLeft:NO target:self action:@selector(chageMode:) tags:@[@"2",@"3"] colors:@[[UIColor grayColor],[UIColor grayColor]]];

    [self addNavigationItemWithImageNames:@[@"翻转镜头",@"闪光灯关闭"] isLeft:NO target:self action:@selector(chageMode:) tags:@[@"2",@"3"]];

    //拍照
    _bg = [[UIView alloc]initWithFrame:CGRectMake(0, IPX_NV+SCREEN_WIDTH, SCREEN_WIDTH, SCREENH_HEIGHT-IPX_NV-SCREEN_WIDTH)];
    _bg.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bg];
    
    _tip = [[UILabel alloc]initWithFrame: CGRectMake(0, 20, SCREEN_WIDTH, 40)];
    _tip.textAlignment=1;
    _tip.text=@"左滑切换";
    _tip.textColor = COLOR_GR(0.7);
    _tip.font = FONTSIZE(12);
    [_bg addSubview:_tip];
    
    //拍照按钮
    [self.view addSubview:self.takeBtn];
    [self.view addSubview:self.centerView];
    [self.view addSubview:whiteView];

}


//打开时 动画
- (void)addMaskLayerIsOpen:(BOOL)isOpen{
    CALayer *layer = [CALayer layer];
    layer.frame = self.centerView.bounds;
    layer.anchorPoint = CGPointMake(0.5, 0.5);
    layer.backgroundColor = [UIColor blackColor].CGColor;
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
    anima.fromValue = isOpen ? @(0) : @(1);
    anima.toValue =  isOpen ? @(1) : @(0);
    anima.duration = 0.3;
    anima.repeatCount = 1;
    anima.removedOnCompletion = NO;
    anima.fillMode=kCAFillModeForwards;
    [layer addAnimation:anima forKey:@"open"];
    self.centerView.layer.mask = layer;
}

#pragma  mark - lazy load

- (AVCaptureSession *)session{
    if (!_session) {
        _session = [[AVCaptureSession alloc]init];
        if ([_session canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
            _session.sessionPreset = AVCaptureSessionPreset1280x720;
        }
    }
    return _session;
}

- (UIButton *)takeBtn{
    if (!_takeBtn) {
        CGFloat w = SCREEN_WIDTH/5;
        _takeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _takeBtn.frame = CGRectMake(0, 0, w, w);
        _takeBtn.center = _bg.center;
        _takeBtn.layer.cornerRadius = w/2;
        _takeBtn.backgroundColor = COLOR_GR(0.7);
        
        CGFloat pad = 6;
        CALayer *la = [CALayer layer];
        la.frame = CGRectMake(-pad, -pad, w+pad*2, w+pad*2);
        la.borderColor = COLOR_GR(0.7).CGColor;
        la.borderWidth = 2;
        la.cornerRadius = w/2+pad;
        [_takeBtn.layer addSublayer:la];
    }
    return _takeBtn;
}

- (UIView *)centerView{
    if (!_centerView) {
        _centerView = [[UIView alloc]initWithFrame:CGRectMake(0, IPX_NV, SCREEN_WIDTH, SCREEN_WIDTH)];
        _centerView.backgroundColor = [UIColor whiteColor];
        
        whiteView = [[UIView alloc]initWithFrame:_centerView.frame];
        whiteView.backgroundColor = [UIColor whiteColor];
    }
    return _centerView;
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
