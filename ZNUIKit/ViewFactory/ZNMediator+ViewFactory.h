//
//  ZNMediator+ViewFactory.h
//  ZNUIKit
//
//  Created by TaKeShi_Mac on 2020/8/2.
//  Copyright © 2020 郑楠楠. All rights reserved.
//

#import "ZNMediator.h"
#import "ZNBaseViewController.h"
#import "ViewFactoryHeader.h"
NS_ASSUME_NONNULL_BEGIN

#define ZNMediatorSharedInstance [ZNMediator sharedInstance]

#define ZNViewControlelr(viewControllerName, viewModelName, params) \
    [ZNMediatorSharedInstance ZNMediator_viewControllerName:viewControllerName\
                                             viewModelClass:viewModelName\
                                                   vmParams:params]

@interface ZNMediator (ViewFactory)



- (ZNBaseViewController *) ZNMediator_viewControllerName:(NSString *)className
                                          viewModelClass:(NSString *)viewModelClass
                                                vmParams:(NSDictionary *)vmParams;

@end

NS_ASSUME_NONNULL_END
