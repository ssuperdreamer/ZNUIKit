//
//  Target_ViewFactory.m
//  ZNUIKit
//
//  Created by TaKeShi_Mac on 2020/8/2.
//  Copyright © 2020 郑楠楠. All rights reserved.
//

#import "Target_ViewFactory.h"

@implementation Target_ViewFactory

//params:包含界面类名，vm类名，vm初始化参数
- (ZNBaseViewController *) action_viewControllerWithParams:(NSDictionary *) params
{
    NSString *viewModelClassName=[params objectForKey:ZNMediatorViewModelName];
    NSDictionary *viewModelParams=[params objectForKey:ZNMediatorViewModelParams];
    Class viewModelClass = NSClassFromString(viewModelClassName);
    ZNBaseViewModel *viewModel=nil;
    if ([viewModelParams count]) {
        viewModel=[viewModelClass mj_objectWithKeyValues:viewModelParams];
    }
    else {
        viewModel=[[viewModelClass alloc] init];
    }
    if (viewModel) {
        NSString *viewControllerClassName=[params objectForKey:ZNMediatorViewControllerName];
        Class viewControllerClass = NSClassFromString(viewControllerClassName);
        //如果界面类不是继承JKZLBaseViewController，就直接返回该界面
        return [[viewControllerClass alloc] initWithViewModel:viewModel];
    }
    return nil;
}
@end
