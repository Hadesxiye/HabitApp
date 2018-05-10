//
//  NeedToDoVC.m
//  habit
//
//  Created by 王浩祯 on 2018/3/19.
//  Copyright © 2018年 王浩祯. All rights reserved.
//

#import "AddNeedToDoVC.h"
#import "NeedToDoVC.h"
#import "BaseTabBarViewController.h"


@interface NeedToDoVC ()

@end

@implementation NeedToDoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavRightButton];
}
#pragma mark - ❀==============❂ 设置导航栏右侧及返回按钮按钮 ❂==============❀
-(void)setNavRightButton
{
    UIBarButtonItem* rigthBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNeeded)];
    
    self.navigationItem.rightBarButtonItem  = rigthBtn;
    //设置导航栏返回时显示的文字
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
}
#pragma mark - ❀==============❂ 导航栏动画 ❂==============❀
-(void)addNeeded{
    AddNeedToDoVC* needToDo = [AddNeedToDoVC new];
    CATransition* amin = [CATransition animation];
    amin.duration = 0.5;
    amin.type = @"oglFlip";
    amin.subtype = kCATransitionFromTop;
    amin.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [self.navigationController.view.layer addAnimation:amin forKey:nil];
    
    //    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:needToDo animated:YES];
    //    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - ❀==============❂ tabbar动画 ❂==============❀
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[BaseTabBarViewController sharedController] hidesTabBar:NO animated:YES];
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
