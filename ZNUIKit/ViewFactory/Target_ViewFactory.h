//
//  Target_ViewFactory.h
//  ZNUIKit
//
//  Created by TaKeShi_Mac on 2020/8/2.
//  Copyright © 2020 郑楠楠. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewFactoryHeader.h"
#import "ZNBaseViewController.h"
#import "ZNBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface Target_ViewFactory : NSObject

- (ZNBaseViewController *) action_viewControllerWithParams:(NSDictionary *) params;

@end

NS_ASSUME_NONNULL_END
