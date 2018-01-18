//
//  UIImage+Utility.m
//  PhotoKitDemo
//
//  Created by Lemon on 2016/11/16.
//  Copyright © 2016年 Lemon. All rights reserved.
//

#import "UIImage+Utility.h"

@implementation UIImage (Utility)
- (UIImage *) maskWithColor:(UIColor *)color{
    CGImageRef maskImage = self.CGImage;
    CGFloat width = self.size.width*self.scale;
    CGFloat height = self.size.height*self.scale;
    CGRect bounds = CGRectMake(0,0,width,height);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmapContext = CGBitmapContextCreate(NULL, width, height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast);
    CGContextClipToMask(bitmapContext, bounds, maskImage);
    CGContextSetFillColorWithColor(bitmapContext, color.CGColor);
    CGContextFillRect(bitmapContext, bounds);
    
    CGImageRef cImage = CGBitmapContextCreateImage(bitmapContext);
    UIImage *coloredImage = [UIImage imageWithCGImage:cImage scale:self.scale orientation:UIImageOrientationUp];
    
    CGContextRelease(bitmapContext);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(cImage);
    
    return coloredImage;
}


- (UIImage *)scalingToAspectRatioForTargetWidth:(CGFloat)targetWidth {
    CGFloat scale = [UIScreen mainScreen].scale;
    float oldWidth = self.size.width;
    float scaleFactor = targetWidth / oldWidth;
    
    float newHeight = floor( self.size.height * scaleFactor);
    float newWidth = floor(oldWidth * scaleFactor);
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(newWidth, newHeight),NO,scale);
    [self drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (NSData *)resetSizeOfImageData:(UIImage *)source_image compressQuality:(CGFloat)compressQuality
{
    return  [self resetSizeOfImageData:source_image referenceSize:30 compressQuality:compressQuality];
}

+ (NSData *)resetSizeOfImageData:(UIImage *)source_image referenceSize:(NSInteger)maxSize compressQuality:(CGFloat)compressQuality
{
    //先调整分辨率
    CGSize newSize = CGSizeMake(source_image.size.width, source_image.size.height);
    NSInteger tempHeight = newSize.height / 1024;
    NSInteger tempWidth = newSize.width / 1024;
    
    if (tempWidth > 1.0 && tempWidth > tempHeight) {
        newSize = CGSizeMake(source_image.size.width / tempWidth, source_image.size.height / tempWidth);
    }
    else if (tempHeight > 1.0 && tempWidth < tempHeight){
        newSize = CGSizeMake(source_image.size.width / tempHeight, source_image.size.height / tempHeight);
    }
    UIGraphicsBeginImageContext(newSize);
    [source_image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //调整大小
    NSData *imageData = UIImageJPEGRepresentation(newImage,1.0);
    NSUInteger sizeOrigin = [imageData length];
    NSUInteger sizeOriginKB = sizeOrigin / 1024;
    if (sizeOriginKB > maxSize) {
        NSData *finallImageData = UIImageJPEGRepresentation(newImage,compressQuality);
        return finallImageData;
    }
    return imageData;
}

+(instancetype)imageWithOriginalName:(NSString *)imageName
{
    
    return [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
}

+(instancetype)imageResizingWithName:(NSString * )imageName
{
    UIImage * image =  [UIImage imageNamed:imageName];
    image  = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
    return  image;
}

+ (instancetype)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (instancetype)image:(UIImage*)image byScalingToSize:(CGSize)targetSize {
    UIImage *sourceImage = image;
    UIImage *newImage = nil;
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = CGPointZero;
    thumbnailRect.size.width  = targetSize.width;
    thumbnailRect.size.height = targetSize.height;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage ;
}


- (UIImage *)imageWithCornerRadius:(CGFloat)cornerRadius{
    
    CGFloat w = self.size.width;
    CGFloat h = self.size.height;
    CGFloat scale = [UIScreen mainScreen].scale;
    // 防止圆角半径小于0，或者大于宽/高中较小值的一半。
    if (cornerRadius < 0)
        cornerRadius = 0;
    else if (cornerRadius > MIN(w, h))
        cornerRadius = MIN(w, h) / 2.;
    
    UIImage *image = nil;
    CGRect imageFrame = CGRectMake(0., 0., w, h);
    UIGraphicsBeginImageContextWithOptions(self.size, NO, scale);
    [[UIBezierPath bezierPathWithRoundedRect:imageFrame cornerRadius:cornerRadius] addClip];
    [self drawInRect:imageFrame];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

/**
 *从图片中按指定的位置大小截取图片的一部分
 * UIImage image 原始的图片
 * CGRect rect 要截取的区域
 */
- (UIImage *)imageFromImageInRect:(CGRect)rect{
    
    //将UIImage转换成CGImageRef
    CGImageRef sourceImageRef = [self CGImage];
    
    //按照给定的矩形区域进行剪裁
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    
    //将CGImageRef转换成UIImage
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    //返回剪裁后的图片
    return [self image:newImage rotation:UIImageOrientationRight];
}

- (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate =M_PI_2;
            rect =CGRectMake(0,0,image.size.height, image.size.width);
            translateX=0;
            translateY= -rect.size.width;
            scaleY =rect.size.width/rect.size.height;
            scaleX =rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate =3 *M_PI_2;
            rect =CGRectMake(0,0,image.size.height, image.size.width);
            translateX= -rect.size.height;
            translateY=0;
            scaleY =rect.size.width/rect.size.height;
            scaleX =rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate =M_PI;
            rect =CGRectMake(0,0,image.size.width, image.size.height);
            translateX= -rect.size.width;
            translateY= -rect.size.height;
            break;
        default:
            rotate =0.0;
            rect =CGRectMake(0,0,image.size.width, image.size.height);
            translateX=0;
            translateY=0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context =UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX,translateY);
    
    CGContextScaleCTM(context, scaleX,scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0,0,rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic =UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}


//图片翻转
- (UIImage *)fixImage{
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformTranslate(transform, self.size.width, 0);
    transform = CGAffineTransformScale(transform, -1, 1);
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
@end
