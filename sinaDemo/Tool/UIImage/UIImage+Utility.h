//
//  UIImage+Utility.h
//  PhotoKitDemo
//
//  Created by Lemon on 2016/11/16.
//  Copyright © 2016年 Lemon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Utility)
/**
 *  根据颜色生成图片
 */
- (UIImage *) maskWithColor:(UIColor *)color;


/**
 *  设置图片宽度，高度同比例设置
 */
- (UIImage *)scalingToAspectRatioForTargetWidth:(CGFloat)targetWidth;

/**
 *  图片上传压缩
 *  @param source_image    原图片
 *  @param compressQuality 压缩系数 0-1
 *                         默认参考大小30kb
 */
+ (NSData *)resetSizeOfImageData:(UIImage *)source_image compressQuality:(CGFloat)compressQuality;

/**
 *  图片上传压缩
 *  @param source_image    原图片
 *  @param maxSize   上传的参考大小**KB
 *  @param compressQuality 压缩系数 0-1
 *  @return                imageData
 */
+ (NSData *)resetSizeOfImageData:(UIImage *)source_image referenceSize:(NSInteger)maxSize compressQuality:(CGFloat)compressQuality;

//加载不渲染的图片
+(instancetype)imageWithOriginalName:(NSString *)imageName;

/**
 *  中心扩展拉伸图片
 */
+(instancetype)imageResizingWithName:(NSString * )imageName;
/**
 *  根据颜色生成图片
 */
+ (instancetype)imageWithColor:(UIColor *)color;
/**
 *  设置图片size
 */
+ (instancetype)image:(UIImage*)image byScalingToSize:(CGSize)targetSize;

/**
 *  设置圆形image
 */
- (UIImage *)imageWithCornerRadius:(CGFloat)cornerRadius;

/**
 *从图片中按指定的位置大小截取图片的一部分
 * CGRect rect 要截取的区域
 */
- (UIImage *)imageFromImageInRect:(CGRect)rect;

- (UIImage *)fixImage;

@end
