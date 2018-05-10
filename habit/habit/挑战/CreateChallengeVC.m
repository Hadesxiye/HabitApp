//
//  CreateChallengeVC.m
//  habit
//
//  Created by 王浩祯 on 2018/3/20.
//  Copyright © 2018年 王浩祯. All rights reserved.
//

#import "CreateChallengeVC.h"
#import "BaseTabBarViewController.h"

@interface CreateChallengeVC ()

@end

@implementation CreateChallengeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = myBackgroundColorYellow;
    [self setNavRightButton];
}
#pragma mark ❀==============❂ 设置导航栏左右按钮 ❂==============❀
-(void)setNavRightButton
{
    //右侧按钮
    UIBarButtonItem* rigthBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(backHome)];
    
    self.navigationItem.rightBarButtonItem  = rigthBtn;
    
    //左侧按钮
    UIBarButtonItem* backBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(backAmin)];
    
    self.navigationItem.leftBarButtonItem  = backBtn;
}
#pragma mark ❀==============❂ 按钮转场动画 ❂==============❀
-(void)backAmin{
    CATransition* amin = [CATransition animation];
    amin.duration = 0.5;
    amin.type = @"rippleEffect";
    amin.subtype = kCATransitionFromRight;
    amin.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [self.navigationController.view.layer addAnimation:amin forKey:nil];
    
    //    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)backHome{
    CATransition* amin = [CATransition animation];
    amin.duration = 0.5;
    /*种类
     oglFlip：页面翻转（单页状态）
     cube:矩形翻转
     moveIn:渐入,  第二页在上，渐变进入覆盖效果
     reveal：揭示效果， 转跳页在下，第一页渐变走
     fade:默认渐变
     pageCurl:翻书页  第一页翻开
     suckEffect:吸走  第一页被吸走
     rippleEffect:水波渐变
     */
    amin.type = @"rippleEffect";
    amin.subtype = kCATransitionFromTop;
    amin.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.navigationController.view.layer addAnimation:amin forKey:nil];
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - ❀==============❂ 导航栏隐藏 ❂==============❀
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[BaseTabBarViewController sharedController] hidesTabBar:YES animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
