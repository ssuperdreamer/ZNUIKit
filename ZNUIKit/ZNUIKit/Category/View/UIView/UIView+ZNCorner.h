//
//  UIView+ZNCorner.h
//  TuTuYouXuan
//
//  Created by 杨鸿翔 on 2020/7/21.
//  Copyright © 2020 ttyx. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ZNCorner)

@property (nonatomic, assign) CACornerMask zn_cornerPosition;

@property (nonatomic, assign) CGFloat  zn_cornerMaskRadius;

-(void) zn_setCornerPosition:(CACornerMask) cornerPosition;

-(void) zn_setCornerRadius:(CGFloat) cornerRadius;

@end

NS_ASSUME_NONNULL_END
