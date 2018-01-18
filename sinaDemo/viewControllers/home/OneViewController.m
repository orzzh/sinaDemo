//
//  OneViewController.m
//  sinaDemo
//
//  Created by wl on 2018/1/3.
//  Copyright https://github.com/orzzh All rights reserved.
//

#import "OneViewController.h"
//#import "YearPickView.h"
//#import "EditPhotoViewController.h"
//#import "audioAnimationView.h"
#import "ProgressView.h"

@interface OneViewController ()
{
    NSArray *ar;
    CGFloat ahp ;
    NSTimer *timer;
    ProgressView *v;
    NSInteger index;
    BOOL isSel;
}

@end

@implementation OneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor brownColor];
    
//    UIButton *b1 = [UIButton buttonWithType:UIButtonTypeCustom];
//    b1.frame = CGRectMake(0, 100, 100, 100);
//    [self.view addSubview:b1];
//    b1.backgroundColor = [UIColor blackColor];
//    [b1 addTarget:self action:@selector(bbb) forControlEvents:UIControlEventTouchUpInside];
//
//    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
//    b.frame = CGRectMake(0, 0, 100, 100);
//    b.center = self.view.center;
//    [self.view addSubview:b];
//    b.backgroundColor = [UIColor blackColor];
//
//    UILongPressGestureRecognizer *ges = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(btn:)];
//    [b addGestureRecognizer:ges];
//
//    v = [[ProgressView alloc]initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 10)];
//    v.backgroundColor = [UIColor grayColor];
//    [self.view addSubview:v];
//
//    index = 0;
//    ahp = 0;
//    isSel = NO;
//    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
   
 
}




- (void)b{
//    CGFloat c = arc4random()%10;
//    v.progress = c/10;
    NSLog(@"%f",ahp);
    [v setSecond:ahp index:index];
    ahp+=0.1;
}

- (void)bbb{
    
//    NSLog(@"删除");
//    if (isSel) {
//        [v deleteLast];
//
//    }else{
//        [v showLast];
//    }
//    isSel = !isSel;
}

- (void)btn:(UILongPressGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateBegan) {
        NSLog(@"开始长按");
        index++;
        timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(b) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
        [timer fire];
    }
    if (sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"结束长按");
        [timer invalidate];
        timer = nil;
    }
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
