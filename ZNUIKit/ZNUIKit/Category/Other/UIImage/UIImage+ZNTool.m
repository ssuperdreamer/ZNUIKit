//
//  UIImage+NNTool.m
//  GameGuestVidio
//
//  Created by 郑楠楠 on 2017/12/1.
//  Copyright © 2017年 郑楠楠. All rights reserved.
//

#import "UIImage+ZNTool.h"

@implementation UIImage (ZNTool)

/** 取图片某一像素的颜色 */
- (UIColor *)zn_colorWithAtPixel:(CGPoint)point
{
    if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, self.size.width, self.size.height), point))
    {
        return nil;
    }
    
    NSInteger pointX = trunc(point.x);
    NSInteger pointY = trunc(point.y);
    CGImageRef cgImage = self.CGImage;
    NSUInteger width = self.size.width;
    NSUInteger height = self.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * 1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    CGContextRef context = CGBitmapContextCreate(pixelData,
                                                 1,
                                                 1,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    CGContextTranslateCTM(context, -pointX, pointY-(CGFloat)height);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
    CGContextRelease(context);
    
    CGFloat red   = (CGFloat)pixelData[0] / 255.0f;
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    CGFloat blue  = (CGFloat)pixelData[2] / 255.0f;
    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

/** 获得灰度图 */
- (UIImage *)zn_convertToGrayImage
{
    int width = self.size.width;
    int height = self.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate(nil,width,height,8,0,colorSpace,kCGImageAlphaNone);
    CGColorSpaceRelease(colorSpace);
    
    if (context == NULL)
    {
        return nil;
    }
    
    CGContextDrawImage(context,CGRectMake(0, 0, width, height), self.CGImage);
    CGImageRef contextRef = CGBitmapContextCreateImage(context);
    UIImage *grayImage = [UIImage imageWithCGImage:contextRef];
    CGContextRelease(context);
    CGImageRelease(contextRef);
    
    return grayImage;
}

/**
 
 对图片进行缩放的工具类
 @param image  需要缩放的图片
 @param size  需要的图片大小
 @return  返回的图片
 */
+(UIImage*)zn_originImage:(UIImage *)image scaleToSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}

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
                                 Angle:(CGFloat)Angle
{
    
    UIView *RootBackView = [[UIView alloc] initWithFrame:CGRectMake(0,0,
                                                                    image.size.width,
                                                                    image.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation( Angle* M_PI / 180);
    RootBackView.transform = t;
    CGSize rotatedSize = RootBackView.frame.size;
    
    UIGraphicsBeginImageContextWithOptions(rotatedSize, NO, image.scale);
    
    CGContextRef theContext = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(theContext, rotatedSize.width/2, rotatedSize.height/2);
    CGContextRotateCTM(theContext, Angle * M_PI / 180);
    CGContextScaleCTM(theContext, 1.0, -1.0);
    
    CGContextDrawImage(theContext,
                       CGRectMake(-image.size.width / 2,
                                  -image.size.height / 2,
                                  image.size.width,
                                  image.size.height),
                       [image CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

// 照相机图片旋转

+ (UIImage *)fixOrientation:(UIImage *)aImage {
      
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
      
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
      
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
              
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
              
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
      
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
              
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
      
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
              
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
      
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


/// 图片缩放
/// @param originalImage <#originalImage description#>
/// @param size <#size description#>
+ (UIImage *)thumbnailWithImage:(UIImage *)originalImage size:(CGSize)size

{

        CGSize originalsize = [originalImage size];

        //原图长宽均小于标准长宽的，不作处理返回原图

        if (originalsize.width<size.width && originalsize.height<size.height)

        {

            return originalImage;

        }

        

        //原图长宽均大于标准长宽的，按比例缩小至最大适应值

        else if(originalsize.width>size.width && originalsize.height>size.height)

        {

            CGFloat rate = 1.0;

            CGFloat widthRate = originalsize.width/size.width;

            CGFloat heightRate = originalsize.height/size.height;

            

            rate = widthRate>heightRate?heightRate:widthRate;

            

            CGImageRef imageRef = nil;

            

            if (heightRate>widthRate)

            {

                imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(0, originalsize.height/2-size.height*rate/2, originalsize.width, size.height*rate));//获取图片整体部分

            }

            else

            {

                imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(originalsize.width/2-size.width*rate/2, 0, size.width*rate, originalsize.height));//获取图片整体部分

            }

            UIGraphicsBeginImageContext(size);//指定要绘画图片的大小

            CGContextRef con = UIGraphicsGetCurrentContext();

            

            CGContextTranslateCTM(con, 0.0, size.height);

            CGContextScaleCTM(con, 1.0, -1.0);

            

            CGContextDrawImage(con, CGRectMake(17, 116, size.width, size.height), imageRef);

            

            UIImage *standardImage = UIGraphicsGetImageFromCurrentImageContext();

            

            UIGraphicsEndImageContext();

            CGImageRelease(imageRef);

            

            return standardImage;

        }

        

        //原图长宽有一项大于标准长宽的，对大于标准的那一项进行裁剪，另一项保持不变

        else if(originalsize.height>size.height || originalsize.width>size.width)

        {

            CGImageRef imageRef = nil;

            

            if(originalsize.height>size.height)

            {

                imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(0, originalsize.height/2-size.height/2, originalsize.width, size.height));//获取图片整体部分

            }

            else if (originalsize.width>size.width)

            {

                imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(originalsize.width/2-size.width/2, 0, size.width, originalsize.height));//获取图片整体部分

            }

            

            UIGraphicsBeginImageContext(size);//指定要绘画图片的大小

 

　 　　CGContextRef con = UIGraphicsGetCurrentContext();

            CGContextTranslateCTM(con, 0.0, size.height);

            CGContextScaleCTM(con, 1.0, -1.0);

            

            CGContextDrawImage(con, CGRectMake(0, 0, size.width, size.height), imageRef);

            

             UIImage *standardImage = UIGraphicsGetImageFromCurrentImageContext();

            NSLog(@"改变后图片的宽度为%f,图片的高度为%f",[standardImage size].width,[standardImage size].height);

            

            UIGraphicsEndImageContext();

            CGImageRelease(imageRef);

            

            return standardImage;

        }

        

        //原图为标准长宽的，不做处理

        else

        {

            return originalImage;

        }

 

}

/**
 
 将图片按最大圆形进行裁剪，并返回裁剪后的图片
 @param image  要裁剪成圆形的图片
 @return  返回已经裁剪完的图片
 */
+(UIImage*)zn_originImage:(UIImage*) image{
    UIImage *finshImage;
    //获取图片尺寸
    CGSize size = image.size;
    
    //开启位图上下文
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    //创建圆形路径
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    
    //设置为裁剪区域
    [path addClip];
    
    //绘制图片
    [image drawAtPoint:CGPointZero];
    
    //获取裁剪后的图片
    finshImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭上下文
    UIGraphicsEndImageContext();
    
    return finshImage;
}

/**
 
 @param image  要进行缩放，并裁剪的图片
 @param size  要裁剪的大小
 @return  返回裁剪并缩小后的图片
 */
+(UIImage*)zn_originImage:(UIImage*) image roundSize:(CGSize) size{
    return [self zn_originImage:[self zn_originImage:image scaleToSize:size]];
}

/**
 对图标按一定标准进行缩放操作,按长宽中的最大值跟standard的比重进行缩放
 @param image 要缩放的图标
 @param standard 缩放的标准值，（就是正方形的边长）
 @return 缩放后的图片
 */
+(UIImage*)zn_zoomImage:(UIImage*) image standard:(CGFloat) standard{
    CGFloat sizeNumber = 1;
    CGFloat max = image.size.height > image.size.width ? image.size.height : image.size.width;
    CGFloat min = image.size.height > image.size.width ? image.size.width : image.size.height;
    if (max > standard) {
        sizeNumber = standard / max;
    }else{
        if (min < standard) {
            sizeNumber = standard / min;
        }
    }
    return [self zn_originImage:image scaleToSize:CGSizeMake(sizeNumber * image.size.width, sizeNumber * image.size.height)];
}

+ (UIImage*) zoomImagewith:(UIImage*) image standard:(CGFloat) standard{
    CGFloat sizenumber = standard/image.size.width;
    return [self zn_originImage:image scaleToSize:CGSizeMake(sizenumber * image.size.width, sizenumber * image.size.height)];
}

- (UIImage*)zn_imageZoomSize:(CGSize) size{
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
 *从图片中按指定的位置大小截取图片的一部分
 * UIImage image 原始的图片
 * CGRect rect 要截取的区域
 */
+ (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect{
    
    //将UIImage转换成CGImageRef
    CGImageRef sourceImageRef = [image CGImage];
    
    //按照给定的矩形区域进行剪裁
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    
    //将CGImageRef转换成UIImage
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    //返回剪裁后的图片
    return newImage;
}

@end
