//
//  HabitNameCell.h
//  habit
//
//  Created by 王浩祯 on 2018/3/23.
//  Copyright © 2018年 王浩祯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HabitNameCell : UITableViewCell
/*
 habit名字的cell 高度60
 */
@property (nonatomic,strong) UITextField* habitNameField;
/*
*  block 参数为textField.text
*/
@property (copy, nonatomic) void(^block)(NSString *);

@end
