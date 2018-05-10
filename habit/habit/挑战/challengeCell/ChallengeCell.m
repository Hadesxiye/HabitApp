//
//  ChallengeCell.m
//  habit
//
//  Created by 王浩祯 on 2018/4/7.
//  Copyright © 2018年 王浩祯. All rights reserved.
//

#import "ChallengeCell.h"

@implementation ChallengeCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.frame = self.bounds;
        
        self.backgroundImageView.userInteractionEnabled = YES;
        [self.backgroundImageView addSubview:self.challengeNameLab];
        [self.backgroundImageView addSubview:self.challengeJoinAmountLab];
        [self.backgroundImageView addSubview:self.challengeJoinOrCompleteBtn];
        [self.backgroundImageView addSubview:self.challengeDetailBtn];
        [self.contentView addSubview:self.backgroundImageView];
        
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //cell 高度 60
    _challengeNameLab.frame = CGRectMake(20, 0, SC_WIDTH/2 - 20, 60);
    _challengeJoinAmountLab.frame = CGRectMake(SC_WIDTH/2, 0, SC_WIDTH/4, 60);
    _backgroundImageView.frame = CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
    _challengeDetailBtn.frame = CGRectMake(0, 0, SC_WIDTH/4 * 3, 60);
    _challengeJoinOrCompleteBtn.frame = CGRectMake(SC_WIDTH/4 * 3, 0, SC_WIDTH/4, 60);
    
    
}

-(UILabel *)challengeNameLab {
    if (!_challengeNameLab) {
        _challengeNameLab = [UILabel new];
        _challengeNameLab.font = [UIFont boldSystemFontOfSize:15];
        _challengeNameLab.textColor = [UIColor blackColor];
        
        _challengeNameLab.backgroundColor = [UIColor blueColor];
    }
    return _challengeNameLab;
}

-(UILabel *)challengeJoinAmountLab {
    if (!_challengeJoinAmountLab) {
        _challengeJoinAmountLab = [UILabel new];
        _challengeJoinAmountLab.font = [UIFont boldSystemFontOfSize:15];
        _challengeJoinAmountLab.textColor = [UIColor blackColor];
        _challengeJoinAmountLab.backgroundColor = [UIColor orangeColor];
    }
    return _challengeJoinAmountLab;
}


-(UIImageView *)backgroundImageView{
    if (!_backgroundImageView) {
        _backgroundImageView = [UIImageView new];
        _backgroundImageView.backgroundColor = [UIColor redColor];
    }
    return _backgroundImageView;
}

-(UIButton *)challengeDetailBtn{
    if (!_challengeDetailBtn) {
        _challengeDetailBtn = [UIButton new];
//        [_challengeDetailBtn setBackgroundImage:[UIImage imageNamed:@"minusIcon.png"] forState:UIControlStateNormal];
        _challengeDetailBtn.backgroundColor = [UIColor grayColor];
        
    }
    return _challengeDetailBtn;
}

-(UIButton *)challengeJoinOrCompleteBtn{
    if (!_challengeJoinOrCompleteBtn) {
        _challengeJoinOrCompleteBtn = [UIButton new];
        _challengeJoinOrCompleteBtn.backgroundColor = [UIColor clearColor];
        
    }
    return _challengeJoinOrCompleteBtn;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
