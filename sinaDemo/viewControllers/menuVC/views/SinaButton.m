//
//  SinaButton.m
//  sinaDemo
//
//  Created by wl on 2018/1/3.
//  Copyright https://github.com/orzzh All rights reserved.
//

#import "SinaButton.h"
#define scale 0.65
@implementation SinaButton


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}
-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    CGFloat newX = 0;
    CGFloat newY = 8;
    CGFloat newWidth = contentRect.size.width;
    CGFloat newHeight = contentRect.size.height*scale-newY;
    return CGRectMake(newX, newY, newWidth, newHeight);
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    
    CGFloat newX = 0;
    CGFloat newY = contentRect.size.height*scale-2;
    CGFloat newWidth = contentRect.size.width;
    CGFloat newHeight = contentRect.size.height-contentRect.size.height*scale;
    return CGRectMake(newX, newY, newWidth, newHeight);
}





@end
