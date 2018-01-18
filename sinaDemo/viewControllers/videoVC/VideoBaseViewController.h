//
//  VideoBaseViewController.h
//  sinaDemo
//
//  Created by wl on 2018/1/16.
//  Copyright © 2018年 https://github.com/orzzh. All rights reserved.
//

#import "BaseViewController.h"
#import <AVFoundation/AVFoundation.h>

/**
    拍照、拍视频父类 页面基本结构
 */
@interface VideoBaseViewController : BaseViewController

//拍照／视频共用
@property(nonatomic,strong) AVCaptureSession           *session;          //输入和输出之间数据传递
@property(nonatomic,strong) AVCaptureDeviceInput       *deviceInput;      //摄像头设备输入的数据
@property(nonatomic,strong) AVCaptureDevice            *videoDevice;      //摄像头设备
@property(nonatomic,strong) AVCaptureVideoPreviewLayer *previewLayer;     //预览层
@property(nonatomic,strong) AVCaptureConnection        *outputConnect;     //输出设备连接

//拍照
@property(nonatomic)AVCaptureMetadataOutput            *output;            //当启动摄像头开始捕获输入
@property (nonatomic)AVCaptureStillImageOutput         *ImageOutPut;       //输出图片
//视频
@property(nonatomic,strong) AVCaptureDevice            *voiceDecice;       //音频设备
@property(nonatomic,strong) AVCaptureMovieFileOutput   *videoOutput;       //视频输出

@property(nonatomic,strong) UIButton *takeBtn;
@property(nonatomic,strong) UIView   *centerView;                          //显示层
@property(nonatomic,assign) BOOL     isPostCamear;                         //是否为后置摄像头 默认yes
@property(nonatomic,strong) UILabel *tip;

- (void)createPhotoCamear:(BOOL)isPhoto;
- (void)chanage;
- (void)stopRun;



@end
