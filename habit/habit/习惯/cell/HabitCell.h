//
//  HabitCell.h
//  habit
//
//  Created by 王浩祯 on 2018/3/21.
//  Copyright © 2018年 王浩祯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HabitCell : UITableViewCell

@property (nonatomic,strong) UILabel* habitNameLab;
@property (nonatomic,strong) UILabel* didAmountLab;
@property (nonatomic,strong) UIImageView* backgroundImageView;
@property (nonatomic,strong) UILabel* notDoAmountLab;
@property (nonatomic,strong) UIButton* addBtn;
@property (nonatomic,strong) UIButton* minBtn;
@property (nonatomic,strong) UIButton* habitDetailBtn;

@end
