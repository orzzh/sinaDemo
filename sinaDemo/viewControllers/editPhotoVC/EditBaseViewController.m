//
//  EditBaseViewController.m
//  sinaDemo
//
//  Created by wl on 2018/1/12.
//  Copyright https://github.com/orzzh All rights reserved.
//

#import "EditBaseViewController.h"

@interface EditBaseViewController ()
@end

@implementation EditBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1];

    [self.view addSubview:self.toolBgView]; //工具栏背景
    [self.view addSubview:self.barTool];
}

#pragma  mark - 子类重写

- (void)cutCencel{
    NSLog(@"底部菜单 cencel");
}
- (void)cutNext{
    NSLog(@"底部菜单 next");
}
- (void)chanageType:(NSInteger)num{
}

#pragma  mark - lazyload

- (UIImageView *)imgView{
    if (!_imgView) {
        _scView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, IPX_NV, SCREEN_WIDTH, SCREEN_WIDTH)];
        [self.view addSubview:_scView];
        
        _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        _imgView.userInteractionEnabled = YES;
        [_scView addSubview:self.imgView];
    }
    return _imgView;
}


- (UIView *)cutView{
    if (!_cutView) {
        _cutView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENH_HEIGHT-IPX-45, SCREEN_WIDTH, 45)];
        _cutView.backgroundColor = [UIColor whiteColor];
        [_cutView setBorderWithTop:YES left:NO bottom:NO right:NO borderColor:COLOR_GR(0.1) borderWidth:1];
        [self.view addSubview:_cutView];
        
        UIButton *cencel = [self getBtn];
        cencel.frame = CGRectMake(0, 1, SCREEN_WIDTH/2, 44);
        [cencel setTitle:@"cencel" forState:UIControlStateNormal];
        [cencel addTarget:self action:@selector(cutCencel) forControlEvents:UIControlEventTouchUpInside];
        [_cutView addSubview:cencel];
        
        UIButton *next = [self getBtn];
        next.frame = CGRectMake(SCREEN_WIDTH/2, 1, SCREEN_WIDTH/2, 44);
        [next setTitle:@"next" forState:UIControlStateNormal];
        [next setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [next addTarget:self action:@selector(cutNext) forControlEvents:UIControlEventTouchUpInside];
        [_cutView addSubview:next];
    }
    return _cutView;
}


- (UIButton *)getBtn{
    UIButton *cencel = [UIButton buttonWithType:UIButtonTypeCustom];
    [cencel setTitleColor:COLOR_GR(0.5) forState:UIControlStateNormal];
    cencel.titleLabel.font = FONTSIZE(14);
    return cencel;
}


- (UIView *)toolBgView{
    if (!_toolBgView) {
        CGFloat height = SCREENH_HEIGHT-(IPX_NV+SCREEN_WIDTH)-IPX-45;
        _toolBgView = [[UIView alloc]initWithFrame:CGRectMake(0, IPX_NV+SCREEN_WIDTH, SCREEN_WIDTH, height)];
        _toolBgView.backgroundColor = [UIColor whiteColor];
    }
    return _toolBgView;
}


- (toolBarView *)barTool{
    if (!_barTool) {
        WeakSelf;
        _barTool = [[toolBarView alloc]initWithFrame:CGRectMake(0, SCREENH_HEIGHT-IPX-45, SCREEN_WIDTH, 45)];
        _barTool.seletedBlock = ^(NSInteger index) {
            [weakSelf chanageType:index];
        };
    }
    return _barTool;
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
