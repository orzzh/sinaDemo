

//
//  NextBtn.m
//  sinaDemo
//
//  Created by wl on 2018/1/9.
//  Copyright https://github.com/orzzh All rights reserved.
//

#import "NextBtn.h"
#import "UIImage+Utility.h"

@implementation NextBtn

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitle:@"下一步" forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 3;
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.layer.borderWidth = 1;
        self.layer.masksToBounds = YES;
        self.titleLabel.font = [UIFont fontWithName:FONT size:14];
        CGSize size = [self sizeWithFont:self.titleLabel.font maxSize:CGSizeMake(100, 25) :@"下一步"];
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, size.width+20, 25);

    }
    return self;
}


- (void)setEnabled:(BOOL)enabled{
    if (enabled) {
//        NSLog(@"yes");
        self.layer.borderWidth = 0;
        self.backgroundColor =[UIColor orangeColor];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    }else{
//        NSLog(@"no");
        self.layer.borderWidth = 1;
        self.backgroundColor = [UIColor whiteColor];
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state{
    [super setTitle:title forState:state];
    CGSize size = [self sizeWithFont:self.titleLabel.font maxSize:CGSizeMake(100, 25) :title];
    self.frame = CGRectMake(0, 0, size.width+20, 30);
}

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize :(NSString *)str
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}


@end
