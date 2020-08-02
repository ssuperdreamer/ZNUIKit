//
//  ZNBaseViewController.h
//  ZNUIKit
//
//  Created by TaKeShi_Mac on 2020/8/2.
//  Copyright © 2020 郑楠楠. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZNBaseViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZNBaseViewController : UIViewController


// 唯一初始化方法
// @param viewModel 传入ViewModel
// @return 实例化控制器对象
- (instancetype)initWithViewModel:(ZNBaseViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END
