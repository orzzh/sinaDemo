//
//  SinaViewController.m
//  sinaDemo
//
//  Created by WL on 2018/1/3.
//  Copyright https://github.com/orzzh All rights reserved.
//

#import "SinaViewController.h"
#import "MenuViewController.h"
#import "TabBar.h"

@interface SinaViewController ()<TabBarDelegate,UIViewControllerTransitioningDelegate>

@property (nonatomic,strong)NSMutableArray *barAry;
@property (nonatomic,strong)UIView *barView;

@end

@implementation SinaViewController


- (instancetype)init{
    self = [super init];
    if (self) {
        TabBar *tabBar = [[TabBar alloc]initWithFrame:self.tabBar.frame];
        tabBar.wlDelegate = self;
        [self setValue:tabBar forKey:@"tabBar"];
    }
    return self;
}


- (void)didSelectedAtIndex:(NSInteger)index{
    if (index == 2) {
        //进入menu页面
        
        MenuViewController *menuVC = [[MenuViewController alloc]init];
        UINavigationController *nv = [[UINavigationController alloc]initWithRootViewController:menuVC];
        nv.transitioningDelegate = self;
        nv.modalPresentationStyle = UIModalPresentationCustom;
        [self.selectedViewController presentViewController:nv animated:YES completion:nil];
    }else{
        self.selectedIndex = index;
    }
}




#pragma mark - UIViewControllerTransitioningDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return [WLTranstionManager managerWithtype:WLTranstionTypeMenu model:WLTranstionModeDismiss];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return [WLTranstionManager managerWithtype:WLTranstionTypeMenu model:WLTranstionModePresent];
}







- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
