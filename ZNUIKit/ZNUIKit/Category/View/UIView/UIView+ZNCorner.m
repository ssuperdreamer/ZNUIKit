//
//  UIView+ZNCorner.m
//  TuTuYouXuan
//
//  Created by 杨鸿翔 on 2020/7/21.
//  Copyright © 2020 ttyx. All rights reserved.
//

#import "UIView+ZNCorner.h"
#import <objc/runtime.h>

static NSString * const ZNCornerPositionKey = @"ZNCornerPositionKey";
static NSString * const ZNCornerRadiusKey = @"ZNCornerRadiusKey";

@implementation UIView (ZNCorner)

static NSString *znMaskName = @"ZN_CornerRadius_Mask";

@dynamic zn_cornerPosition;
- (CACornerMask) zn_cornerPosition {
    CACornerMask position = [objc_getAssociatedObject(self, &ZNCornerPositionKey) integerValue];
    return position;
}

-(void) setZn_cornerPosition:(CACornerMask)zn_cornerPosition {
    objc_setAssociatedObject(self, &ZNCornerPositionKey, @(zn_cornerPosition), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@dynamic zn_cornerMaskRadius;
-(CGFloat) zn_cornerMaskRadius {
    return  [objc_getAssociatedObject(self, &ZNCornerRadiusKey) floatValue];
}

-(void) setZn_cornerMaskRadius:(CGFloat)zn_cornerMaskRadius {
    objc_setAssociatedObject(self, &ZNCornerRadiusKey, @(zn_cornerMaskRadius), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}



+(void) load {
    SEL orignal = @selector(layoutSublayersOfLayer:);
    SEL new = NSSelectorFromString([@"zn_" stringByAppendingString:NSStringFromSelector(orignal)]);
    zn_swizzle(self,orignal,new);
}

void zn_swizzle(Class c, SEL orignal, SEL new) {
    Method orignalMethod = class_getInstanceMethod(c, orignal);
    Method newMethod = class_getInstanceMethod(c, new);

    method_exchangeImplementations(orignalMethod, newMethod);
}

-(void) zn_layoutSublayersOfLayer:(CALayer *) layer {
    [self zn_layoutSublayersOfLayer:layer];
    if (self.zn_cornerMaskRadius > 0) {
        if (@available(iOS 11.0, *)) {
        } else {
            if (self.layer.mask && ![self.layer.mask.name isEqualToString:znMaskName]) {
                return;
            }
            
            CAShapeLayer *cornerMaskLayer = [CAShapeLayer layer];
            cornerMaskLayer.name = znMaskName;
            UIRectCorner rectCorner = 0;
            
            if ((self.zn_cornerPosition & kCALayerMinXMinYCorner) == kCALayerMinXMinYCorner) {
                rectCorner |= UIRectCornerTopLeft;
            }
            if ((self.zn_cornerPosition & kCALayerMaxXMinYCorner) == kCALayerMaxXMinYCorner) {
                rectCorner |= UIRectCornerTopRight;
            }
            if ((self.zn_cornerPosition & kCALayerMinXMaxYCorner) == kCALayerMinXMaxYCorner) {
                rectCorner |= UIRectCornerBottomLeft;
            }
            if ((self.zn_cornerPosition & kCALayerMaxXMaxYCorner) == kCALayerMaxXMaxYCorner) {
                rectCorner |= UIRectCornerBottomRight;
            }
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rectCorner cornerRadii:CGSizeMake(self.zn_cornerMaskRadius, self.zn_cornerMaskRadius)];
            cornerMaskLayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
            cornerMaskLayer.path = path.CGPath;
            self.layer.mask = cornerMaskLayer;
        }

    }
}
CG_INLINE CGFloat
flat(CGFloat floatValue) {
    return flatSpecificScale(floatValue, 0);
}

CG_INLINE CGFloat
flatSpecificScale(CGFloat floatValue, CGFloat scale) {
    floatValue = floatValue == CGFLOAT_MIN ? 0 : floatValue;;
    scale = scale ?: [[UIScreen mainScreen] scale];
    CGFloat flattedValue = ceil(floatValue * scale) / scale;
    return flattedValue;
}

-(void) zn_setCornerRadius:(CGFloat) cornerRadius {
    BOOL cornerRadiusChanged = flat(cornerRadius) != flat(self.zn_cornerMaskRadius);
    self.zn_cornerMaskRadius = cornerRadius;
    if (@available(iOS 11, *)) {
        [self.layer setCornerRadius:cornerRadius];
    } else {
        if (self.zn_cornerPosition && ![self hasFourCornerRadius]) {
            [self.layer setCornerRadius:0];
        } else {
            [self.layer setCornerRadius:cornerRadius];
        }
        if (cornerRadiusChanged) {
            [self setNeedsLayout];
        }
    }
}

-(void) zn_setCornerPosition:(CACornerMask) cornerPosition {
    BOOL maskedCornersChanged = cornerPosition != self.zn_cornerPosition;
    self.zn_cornerPosition = cornerPosition;
    
    if (@available(iOS 11, *)) {
        [self.layer setMaskedCorners:cornerPosition];
    } else {
        if (cornerPosition && ![self hasFourCornerRadius]) {
            [self.layer setCornerRadius:0];
        }
        if (maskedCornersChanged) {
            // 需要刷新mask
            if ([NSThread isMainThread]) {
                [self setNeedsLayout];
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self setNeedsLayout];
                });
            }
        }
    }
}





- (BOOL) hasFourCornerRadius {
    return (self.zn_cornerPosition & kCALayerMinXMinYCorner) == kCALayerMinXMinYCorner &&
           (self.zn_cornerPosition & kCALayerMaxXMinYCorner) == kCALayerMaxXMinYCorner &&
           (self.zn_cornerPosition & kCALayerMinXMaxYCorner) == kCALayerMinXMaxYCorner &&
           (self.zn_cornerPosition & kCALayerMaxXMaxYCorner) == kCALayerMaxXMaxYCorner;
}
@end
