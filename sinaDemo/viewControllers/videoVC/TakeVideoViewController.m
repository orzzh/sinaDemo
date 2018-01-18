//
//  TakeVideoViewController.m
//  sinaDemo
//
//  Created by wl on 2018/1/16.
//  Copyright © 2018年 https://github.com/orzzh. All rights reserved.
//

#import "TakeVideoViewController.h"
#import <CoreMotion/CoreMotion.h>
#import "VideoTool.h"
#import "VideoMaxTool.h"
#import "ProgressView.h"

#define MAX_TIME 12

@interface TakeVideoViewController ()<AVCaptureFileOutputRecordingDelegate>

@property (nonatomic,strong)UIButton *nextBtn;
@property (nonatomic,strong)UIButton *returnBtn;
@property (nonatomic,strong)UIButton *delectBtn;
@property (nonatomic,strong)ProgressView *progressView;

@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,strong)NSMutableArray *pathAry;
@property (nonatomic,strong)NSMutableArray *timeAry;
@property (nonatomic,assign)CGFloat videoTime;
@property (nonatomic,strong) CMMotionManager *motionManager;
@property (nonatomic,assign)NSInteger motionStatus; //0左转 1正常 2右转

@end

@implementation TakeVideoViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!self.isPostCamear) {
        [self chanage];
    }
}

- (void)createCamear{   //    初始化拍视频
    [self createPhotoCamear:NO];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _pathAry = [[NSMutableArray alloc]init];
    _timeAry = [[NSMutableArray alloc]init];
    _videoTime = 0;
    _motionStatus = 1;
    self.tip.text=@"右滑切换";

    UISwipeGestureRecognizer * ges= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(goPhoto)];
    [ges setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:ges];
    
    [self.takeBtn setTitle:@"按住拍" forState:UIControlStateNormal];
    [self.takeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.takeBtn.titleLabel.font = FONTSIZE(15);
    UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longAction:)];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.takeBtn addGestureRecognizer:tapGes];
    [self.takeBtn addGestureRecognizer:longGes];
    
    _progressView = [[ProgressView alloc]initWithFrame:CGRectMake(0, IPX_NV+SCREEN_WIDTH, SCREEN_WIDTH, 5)];
    _progressView.backgroundColor = [UIColor grayColor];
    _progressView.maxSecond = MAX_TIME;
    [self.view addSubview:_progressView];
    
    [self createMotion];
}

#pragma mark - AVCaptureFileOutputRecordingDelegate

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections{
    NSLog(@"开始录制");
    [self timerStar];
}
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error{
    NSLog(@"录制结束");
    NSLog(@"%@",outputFileURL);
    [_pathAry addObject:outputFileURL];
    [_timeAry addObject:[NSString stringWithFormat:@"%f",_videoTime]];
    [self checkPathAry];
}

- (void)checkPathAry{    //检查视频数组 刷新操作按钮
    if (_pathAry.count == 0) {
        self.nextBtn.hidden = YES;
        self.returnBtn.hidden = YES;
        self.delectBtn.hidden = YES;
    }else{
        self.nextBtn.hidden = NO;
        self.returnBtn.hidden = NO;
        self.delectBtn.hidden = YES;
    }
}

#pragma mark - Action

- (void)tapAction:(UITapGestureRecognizer *)sender{
    NSLog(@"点击");
}

- (void)longAction:(UILongPressGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateBegan) {
        NSLog(@"开始长按");
        [self checkPathAry];
        self.outputConnect.videoOrientation=[self.previewLayer connection].videoOrientation;
        NSString *outFileName = [VideoTool getOutPath];
        NSURL *fileUrl=[NSURL fileURLWithPath:outFileName];
        [self.videoOutput startRecordingToOutputFileURL:fileUrl recordingDelegate:self];

    }
    if (sender.state == UIGestureRecognizerStateEnded ||
        sender.state == UIGestureRecognizerStateFailed) {
        NSLog(@"结束长按");
        [self timerEnd];
        if ([self.videoOutput isRecording]) {
            [self.videoOutput stopRecording];
        }
    }
}

- (void)nextAction{
    NSLog(@"合并视频 进入视频编辑");
    [VideoMaxTool videoMixWithURLs:self.pathAry outPath:[VideoTool getOutPath] block:^(NSURL *url) {
//        weakself.outUrl = url;
//        [weakself.playView setVideoUrl:url isMax:YES];
        NSLog(@"合并结束");
        [VideoTool saveVideoWithURL:url];

    }];
}
- (void)returnAction{
    self.returnBtn.hidden = YES;
    self.delectBtn.hidden = NO;
    [_progressView showLast];
}
- (void)delectAction{
    [_progressView deleteLast];
    [[NSFileManager defaultManager]removeItemAtPath:[_pathAry lastObject] error:nil];
    [_pathAry removeObjectAtIndex:_pathAry.count-1];
    [_timeAry removeObjectAtIndex:_timeAry.count-1];
    _videoTime = [[_timeAry lastObject] integerValue];
    [self checkPathAry];
}

- (void)timerStar{
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(refreshProgress) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
    [_timer fire];
}
- (void)timerEnd{
    [_timer invalidate];
    _timer  = nil;
}
- (void)refreshProgress{
    [_progressView setSecond:_videoTime index:_pathAry.count];
    _videoTime += 0.1;
    if (_videoTime>MAX_TIME) {
        [self timerEnd];
    }
}

- (void)chageMode:(UIButton *)sender{
    if (sender.tag == 2) {//闪光灯
        NSLog(@"点击了闪光灯");
        return;
    }
    NSLog(@"点击了翻转");
    //翻转摄像头
    [self chanage];
    self.isPostCamear = !self.isPostCamear;

    if (self.block) {
        self.block(self.isPostCamear);
    }
}


- (void)goPhoto{
    [self.navigationController popViewControllerAnimated:NO];
}



- (void)dealloc{
    if (_pathAry>0) {
        for (NSString *path in _pathAry) {
            [[NSFileManager defaultManager]removeItemAtPath:path error:nil];
        }
    }
}




- (void)createMotion{
    //初始化全局管理对象
    CMMotionManager *manager = [[CMMotionManager alloc] init];
    self.motionManager = manager;
    
    if ([self.motionManager isDeviceMotionAvailable]) {
        manager.deviceMotionUpdateInterval = 1;
        [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue]
                                                withHandler:^(CMDeviceMotion * _Nullable motion,
                                                              NSError * _Nullable error) {
                                                    
                                                    // Gravity 获取手机的重力值在各个方向上的分量，根据这个就可以获得手机的空间位置，倾斜角度等
                                                    double gravityX = motion.gravity.x;
                                                    double gravityY = motion.gravity.y;
//                                                    double gravityZ = motion.gravity.z;
                                                    
                                                    // 获取手机的倾斜角度(zTheta是手机与水平面的夹角， xyTheta是手机绕自身旋转的角度)：
//                                                    double zTheta = atan2(gravityZ,sqrtf(gravityX * gravityX + gravityY * gravityY)) / M_PI * 180.0;
                                                    double xyTheta = atan2(gravityX, gravityY) / M_PI * 180.0;
                                                    
//                                                    NSLog(@"手机与水平面的夹角 --- %.4f, 手机绕自身旋转的角度为 --- %.4f", zTheta, xyTheta);
                                                    if (xyTheta>-120 && xyTheta<-40 && _motionStatus !=0) {
                                                        //左转
                                                        _motionStatus =0;
                                                        [UIView animateWithDuration:0.3 animations:^{
                                                            self.takeBtn.transform = CGAffineTransformMakeRotation(M_PI/2);
                                                        }];
                                                    }else if (xyTheta>40 && xyTheta<120 && _motionStatus !=2){
                                                        //右转
                                                        _motionStatus =2;
                                                        [UIView animateWithDuration:0.3 animations:^{
                                                            self.takeBtn.transform = CGAffineTransformMakeRotation(-M_PI/2);
                                                        }];
                                                    }else if((_motionStatus == 2 && (xyTheta<40 || xyTheta>120)) ||
                                                              (_motionStatus == 0 && (xyTheta<-120 || xyTheta>-40))){
                                                        //正常
                                                        _motionStatus =1;
                                                        [UIView animateWithDuration:0.3 animations:^{
                                                            self.takeBtn.transform = CGAffineTransformIdentity;
                                                        }];
                                                    }
                                                }];
    }
}


#pragma mark - lazyload
- (UIButton *)nextBtn{
    if (!_nextBtn) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextBtn.frame = CGRectMake(0, 0, self.takeBtn.width, self.takeBtn.height);
        _nextBtn.center = CGPointMake(SCREEN_WIDTH-(SCREEN_WIDTH/2-self.takeBtn.width)/2, self.takeBtn.center.y);
        [_nextBtn setTitle:@">" forState:UIControlStateNormal];
        [_nextBtn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
        [self setBorder:_nextBtn];
        [self.view addSubview:_nextBtn];
    }
    return _nextBtn;
}
- (UIButton *)returnBtn{
    if (!_returnBtn) {
        _returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _returnBtn.frame = CGRectMake(0, 0, self.takeBtn.width, self.takeBtn.height);
        _returnBtn.center = CGPointMake((SCREEN_WIDTH/2-self.takeBtn.width)/2, self.takeBtn.center.y);
        [_returnBtn setTitle:@"<" forState:UIControlStateNormal];
        [_returnBtn addTarget:self action:@selector(returnAction) forControlEvents:UIControlEventTouchUpInside];
        [self setBorder:_returnBtn];
        [self.view addSubview:_returnBtn];
    }
    return _returnBtn;
}
- (UIButton *)delectBtn{
    if (!_delectBtn) {
        _delectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _delectBtn.frame = CGRectMake(0, 0, self.takeBtn.width, self.takeBtn.height);
        _delectBtn.center = CGPointMake((SCREEN_WIDTH/2-self.takeBtn.width)/2, self.takeBtn.center.y);
        [_delectBtn setTitle:@"del" forState:UIControlStateNormal];
        [_delectBtn addTarget:self action:@selector(delectAction) forControlEvents:UIControlEventTouchUpInside];
        [self setBorder:_delectBtn];
        [self.view addSubview:_delectBtn];
    }
    return _delectBtn;
}

- (void)setBorder:(UIButton *)btn{
    btn.layer.cornerRadius = btn.width/2;
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = [UIColor orangeColor].CGColor;
    btn.backgroundColor = [UIColor clearColor];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
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
