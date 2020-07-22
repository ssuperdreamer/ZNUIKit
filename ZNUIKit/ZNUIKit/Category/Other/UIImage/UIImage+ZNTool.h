//
//  UIImage+NNTool.h
//  GameGuestVidio
//
//  Created by 郑楠楠 on 2017/12/1.
//  Copyright © 2017年 郑楠楠. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ZNTool)

/**
 图片放大
 @param size 放大的大小
 @return 放大后的图片
 */
- (UIImage*)zn_imageZoomSize:(CGSize) size;

/** 取图片某一像素的颜色 */
- (UIColor *)zn_colorWithAtPixel:(CGPoint)point;

/** 获得灰度图 */
- (UIImage *)zn_convertToGrayImage;

/**
 
 对图片进行缩放的工具类
 @param image  需要缩放的图片
 @param size  需要的图片大小
 @return  返回的图片
 */
+(UIImage*)zn_originImage:(UIImage *)image scaleToSize:(CGSize)size;

/// 图片缩放
/// @param originalImage <#originalImage description#>
/// @param size <#size description#>
+ (UIImage *)thumbnailWithImage:(UIImage *)originalImage size:(CGSize)size;

/**
 *从图片中按指定的位置大小截取图片的一部分
 * UIImage image 原始的图片
 * CGRect rect 要截取的区域
 */
+ (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect;

/**
 
 将图片按最大圆形进行裁剪，并返回裁剪后的图片
 @param image  要裁剪成圆形的图片
 @return  返回已经裁剪完的图片
 */
+(UIImage*)zn_originImage:(UIImage*) image;

/**

 @param image  要进行缩放，并裁剪的图片
 @param size  要裁剪的大小
 @return  返回裁剪并缩小后的图片
 */
+(UIImage*)zn_originImage:(UIImage*) image roundSize:(CGSize) size;

/**
 对图标按一定标准进行缩放操作
 @param image 要缩放的图标
 @param standard 缩放的标准值，（就是正方形的边长）
 @return 缩放后的图片
 */
+(UIImage*)zn_zoomImage:(UIImage*) image standard:(CGFloat) standard;

/**
 按图片宽跟standard的比重进行缩放
 @param image 要缩放的图片
 @param standard 标准
 @return 缩放后的图片
 */
//+ (UIImage*)zn_zoomImagewith:(UIImage*) image standard:(CGFloat) standard;

#pragma mark --------旋转
//--------------------------------------------------旋转
/**
 *  得到旋转后的图片
 *
 *  @param image 原图
 *  @param Angle 角度（0~360）
 *
 *  @return 新生成的图片
 */
+(UIImage  *)GetRotationImageWithImage:(UIImage *)image
                                 Angle:(CGFloat)Angle;

// 照相机图片旋转

+ (UIImage *)fixOrientation:(UIImage *)aImage;
@end
