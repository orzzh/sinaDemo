//
//  MenuViewController.m
//  sinaDemo
//
//  Created by wl on 2018/1/3.
//  Copyright https://github.com/orzzh All rights reserved.
//

#import "MenuViewController.h"
#import "WLPhotoViewController.h"
#import "TakePhotoViewController.h"

@interface MenuViewController ()
{
    NSInteger num;//即将显示次数a
}

@end

@implementation MenuViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    if (num == 0) {
        num ++;
    }else{
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0];
    [self.view addSubview:self.menuView];
    [self.view addSubview:self.cencelView];
    [self.view addSubview:_cencel];
    num = 0;
}

#pragma mark - Action

- (void)star{
    [self.menuView anmationStar:YES];
}

- (void)pushVC:(NSInteger)num{
    
    UIViewController *v;
    if (num == 1) {
        v = [[TakePhotoViewController alloc]init];
    }else{
        v = [[WLPhotoViewController alloc]init];
    }
    
    
    UINavigationController *nv = [[UINavigationController alloc]initWithRootViewController:v];
    [self.navigationController presentViewController:nv animated:YES completion:^{
        self.view.hidden = YES;
    }];
    NSLog(@"? %zd",num);
}

- (void)cencelAct{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - lazyload

- (WLMenuView *)menuView{
    if (!_menuView) {
        CGRect rect = CGRectMake(0, SCREENH_HEIGHT-SCREEN_WIDTH/2-49-50-IPX, self.view.width, self.view.width/2);
        NSArray *titleAry = @[@"文字",@"拍摄",@"相册",@"直播",@"光影秀",@"提问",@"签到",@"点评"];
        NSArray *imageAry = @[];
        _menuView = [[WLMenuView alloc]initWithFrame:rect titleAry:titleAry imageAry:imageAry];
        WeakSelf;
        _menuView.block = ^(NSInteger num) {
            [weakSelf pushVC:num];
        };
    }
    return _menuView;
}

- (UIView *)cencelView{
    if (!_cencelView) {
        _cencelView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENH_HEIGHT-49-IPX, SCREEN_WIDTH, 49)];
        _cencelView.backgroundColor = [UIColor whiteColor];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cencelAct)];
        [_cencelView addGestureRecognizer:tap];
        
        _cencel = [[UIButton alloc] init];
        _cencel.frame = CGRectMake(0, 0, 50, 44);
        _cencel.center = CGPointMake(self.view.center.x, SCREENH_HEIGHT- 49/2 -IPX);
        [_cencel setImage:[UIImage imageNamed:@"+black"] forState:UIControlStateNormal];
        [_cencel addTarget:self action:@selector(cencelAct) forControlEvents:UIControlEventTouchUpInside];
        [_cencelView setBorderWithTop:YES left:NO bottom:NO right:NO borderColor:[UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:0.7] borderWidth:1];
    }
    return _cencelView;
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
