//
//  ZNMediator+ViewFactory.m
//  ZNUIKit
//
//  Created by TaKeShi_Mac on 2020/8/2.
//  Copyright © 2020 郑楠楠. All rights reserved.
//

#import "ZNMediator+ViewFactory.h"


@implementation ZNMediator (ViewFactory)

//返回通用的界面对象
//className:界面类名
//viewModelClass:vm类名,
//vmParams:初始化vm参数
- (ZNBaseViewController *)ZNMediator_viewControllerName:(NSString *)className
                                         viewModelClass:(NSString *)viewModelClass
                                               vmParams:(NSDictionary *)vmParams
{

    if ( ![className length] || ![viewModelClass length]) {
        return nil;
    }
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    [params setObject:className forKey:ZNMediatorViewControllerName];
    [params setObject:viewModelClass forKey:ZNMediatorViewModelName];
    if (vmParams) {
        [params setObject:vmParams forKey:ZNMediatorViewModelParams];
    }
    
    ZNBaseViewController *viewController = [self performTarget:View_Factory
                                                          action:ViewModel_Factory
                                                          params:@[params]
                                               shouldCacheTarget:NO];
    if ( [viewController isKindOfClass:[UIViewController class]] )
    {
        // view controller 交付出去之后，可以由外界选择是push还是present
        return viewController;
    } else {
        // 这里处理异常场景，具体如何处理取决于产品
        return nil;
    }
}

@end
