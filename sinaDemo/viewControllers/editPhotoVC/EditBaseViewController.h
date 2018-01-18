//
//  EditBaseViewController.h
//  sinaDemo
//
//  Created by wl on 2018/1/12.
//  Copyright https://github.com/orzzh All rights reserved.
//

#import "BaseViewController.h"
#import "toolBarView.h"


/**
    图片编辑父类 页面基本结构
 */
@interface EditBaseViewController : BaseViewController

@property (nonatomic,strong)UIScrollView *scView;
@property (nonatomic,strong)UIImageView *imgView;
@property (nonatomic,strong)UIView *cutView;                //取消 或 完成编辑 view
@property (nonatomic,copy)void(^block)(UIImage *img);       //返回马赛克 或 裁剪后图片
@property (nonatomic,strong)toolBarView *barTool;           //底部菜单
@property (nonatomic,strong)UIView *toolBgView;             //菜单item背景

@end
