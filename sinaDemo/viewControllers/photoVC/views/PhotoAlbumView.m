//
//  PhotoAlbumView.m
//  sinaDemo
//
//  Created by wl on 2018/1/8.
//  Copyright https://github.com/orzzh All rights reserved.
//

#import "PhotoAlbumView.h"
#import "wlPohotoManager.h"
#import "PhotoVolumeModel.h"
#import "AlbumTableViewCell.h"

static NSString *cellID = @"cellid";

@interface PhotoAlbumView()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL isOpen;
    UIView *bgView;
}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray<PhotoVolumeModel*> *volumeAry; //相册信息


@end
@implementation PhotoAlbumView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        isOpen = NO;
        [self createData];
        [self createUI];
    }
    return self;
}

#pragma  mark - 打开关闭

- (void)open{
    if (isOpen) {
        [self closeAnimation]; //关闭动画
    }else{
        [self openAnimotion];  //打开动画
    }
    isOpen = !isOpen;
}


- (void)closeAnimation{
    [UIView animateWithDuration:0.4 animations:^{
        bgView.alpha = 0;
        self.tableView.transform = CGAffineTransformTranslate(self.tableView.transform, 0, -self.tableView.height);
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}


- (void)openAnimotion{
    self.hidden = NO;
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.75 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
        bgView.alpha = 0.3;
        self.tableView.transform = CGAffineTransformIdentity;
    }completion:nil];
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _volumeAry.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AlbumTableViewCell *cell = (AlbumTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[AlbumTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    PhotoVolumeModel *volomeModel = [_volumeAry objectAtIndex:indexPath.row];
    [cell setPhotoVolumeModel:volomeModel];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.block) {
        self.block([_volumeAry objectAtIndex:indexPath.row]);
    }
    [self open];
}

- (void)createData{
    
    _volumeAry = [PhotoVolumeModel getVolumeModels];
    
}

- (void)createUI{
    CGFloat height = self.height*2/3;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -50, SCREEN_WIDTH, height)];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    _tableView.transform = CGAffineTransformTranslate(self.tableView.transform, 0, -self.tableView.height);
    _tableView.rowHeight = 60;
    
    bgView = [[UIView alloc]initWithFrame:self.bounds];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(open)];
    [bgView addGestureRecognizer:tap];
    
    [self addSubview:bgView];
    [self addSubview:_tableView];
}
@end
