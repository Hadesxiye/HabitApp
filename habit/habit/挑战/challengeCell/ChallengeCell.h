//
//  ChallengeCell.h
//  habit
//
//  Created by 王浩祯 on 2018/4/7.
//  Copyright © 2018年 王浩祯. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChallengeCell : UITableViewCell

@property (nonatomic,strong) UILabel* challengeNameLab;
@property (nonatomic,strong) UILabel* challengeJoinAmountLab;
@property (nonatomic,strong) UIImageView* backgroundImageView;
@property (nonatomic,strong) UIButton* challengeJoinOrCompleteBtn;
@property (nonatomic,strong) UIButton* challengeDetailBtn;

@end
