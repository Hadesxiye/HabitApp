//
//  AddHabitVC.h
//  habit
//
//  Created by 王浩祯 on 2018/3/20.
//  Copyright © 2018年 王浩祯. All rights reserved.
//

#import "ViewController.h"

@interface AddHabitVC : ViewController

//habit页面遍历数据库，得到最大id ，id+1 传给habitnewIDStr
@property (nonatomic,strong) NSString* habitNewIDStr;

@end
