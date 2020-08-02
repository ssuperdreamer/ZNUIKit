//
//  ZNBaseViewController.m
//  ZNUIKit
//
//  Created by TaKeShi_Mac on 2020/8/2.
//  Copyright © 2020 郑楠楠. All rights reserved.
//

#import "ZNBaseViewController.h"

@interface ZNBaseViewController ()

@property (nonatomic,strong) ZNBaseViewModel *viewModel;

@end

@implementation ZNBaseViewController


- (instancetype)initWithViewModel:(ZNBaseViewModel *)viewModel
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _viewModel = viewModel;
    }
    return self;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
