//
//  DevelopingData.m
//  habit
//
//  Created by 王浩祯 on 2018/4/5.
//  Copyright © 2018年 王浩祯. All rights reserved.
//

#import "DevelopingData.h"
#import "BaseTabBarViewController.h"

@interface DevelopingData ()

@end

@implementation DevelopingData

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = myBackgroundColorYellow;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - ❀==============❂ 导航栏隐藏 ❂==============❀
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[BaseTabBarViewController sharedController] hidesTabBar:YES animated:YES];
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
