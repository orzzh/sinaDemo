//
//  YearPickView.m
//  sinaDemo
//
//  Created by wl on 2018/1/9.
//  Copyright https://github.com/orzzh All rights reserved.
//

#import "YearPickView.h"

#define  PIC_HEIGHT 300

@interface YearPickView()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIPickerView *pickView;
    NSMutableArray *dataAry;
    NSString *currYear;
    UIButton *cencelBtn;
    UILabel *title;
    UIButton *nextBtn;
    UIView *mask;
    UIView *toolBar;
}
@end
@implementation YearPickView

- (instancetype)init{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT)];
    if (self) {
        [self creaetUI];
    }
    return self;
}

#pragma mark - data

- (void)setMaxYear:(NSString *)maxyear minYear:(NSString *)minyear{
    
    NSString *curr = [self getDateYear];
    if ([curr integerValue] <= [maxyear integerValue] &&
        [curr integerValue] >= [minyear integerValue]) {
        //默认显示 今年
        currYear = curr;
    }else{
        //默认显示 minyear
        currYear = minyear;
    }
    
    dataAry = [[NSMutableArray alloc]init];
    for (NSInteger i = [minyear integerValue];i<=[maxyear integerValue]; i++) {
        [dataAry addObject:[NSString stringWithFormat:@"%zd",i]];
    }
    
    [self showCurrYear];
    [pickView reloadAllComponents];
}

- (void)showCurrYear{
    for (NSString *y in dataAry) {
        if ([y isEqualToString:currYear]) {
            [pickView selectRow:[dataAry indexOfObject:y] inComponent:0 animated:NO];
        }
    }
}


#pragma mark - Action

- (void)nextAct{
    if (self.selectBlock) {
        self.selectBlock(currYear);
    }
    [self cencel];
}

- (void)cencel{
    toolBar.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:0.4 animations:^{
        mask.alpha = 0;
        toolBar.transform = CGAffineTransformTranslate(pickView.transform, 0, PIC_HEIGHT+toolBar.height);
        
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)show{
    [[UIApplication sharedApplication].windows[0] addSubview:self];
    toolBar.transform = CGAffineTransformTranslate(pickView.transform, 0, PIC_HEIGHT+toolBar.height);

    [UIView animateWithDuration:0.4 animations:^{
        mask.alpha = 0.3;
        toolBar.transform = CGAffineTransformIdentity;
    }];
}

//获取年
- (NSString *)getDateYear{
    
    NSDate* dt = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned unitFlags = NSCalendarUnitYear;
    NSDateComponents* comp = [gregorian components: unitFlags
                                          fromDate:dt];
    return [NSString stringWithFormat:@"%zd",comp.year];
}

#pragma mark - UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return dataAry.count;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return SCREEN_WIDTH;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return dataAry[row];
}

- (UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *v= [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    v.textAlignment = 1;
    v.text = dataAry[row];
    v.textColor = [UIColor blackColor];
    view.backgroundColor = [UIColor orangeColor];
    return v;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    currYear = [NSString stringWithFormat:@"%@",dataAry[row]];
}

- (void)layoutSubviews{
    pickView.frame = CGRectMake(0, 50, SCREEN_WIDTH, PIC_HEIGHT);
    cencelBtn.frame = CGRectMake(0, 0, 50, 50);
    nextBtn.frame = CGRectMake(SCREEN_WIDTH-50, 0, 50, 50);

}


- (void)creaetUI{
    self.backgroundColor = [UIColor clearColor];
    
    mask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT)];
    mask.backgroundColor = [UIColor blackColor];
    mask.alpha = 0;
    [self addSubview:mask];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cencel)];
    [mask addGestureRecognizer:tap];
    
    
    toolBar = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENH_HEIGHT-PIC_HEIGHT-50, SCREEN_WIDTH, PIC_HEIGHT+50)];
    [self addSubview:toolBar];
    
    pickView = [[UIPickerView alloc]init];
    pickView.backgroundColor = [UIColor redColor];
    pickView.delegate = self;
    pickView.dataSource = self;
    [toolBar addSubview:pickView];
    
    title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    title.textAlignment =1;
    title.text = @"选择年份";
    title.textColor = [UIColor blackColor];
    title.backgroundColor = [UIColor whiteColor];
    title.font = [UIFont fontWithName:@"" size:15];
    [toolBar addSubview:title];
    
    cencelBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    cencelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cencelBtn setTitle:@"X" forState:UIControlStateNormal];
    //    [cencelBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [cencelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cencelBtn addTarget:self action:@selector(cencel) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:cencelBtn];
    
    nextBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [nextBtn setTitle:@"完成" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextAct) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:nextBtn];
    
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 1)];
    v.backgroundColor = [UIColor grayColor];
    v.alpha=0.3;
    [toolBar addSubview:v];
}

@end
