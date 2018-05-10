//
//  AddHabitCell.m
//  habit
//
//  Created by 王浩祯 on 2018/3/22.
//  Copyright © 2018年 王浩祯. All rights reserved.
//

#import "AddHabitCell.h"

@implementation AddHabitCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.frame = self.bounds;
        self.contentView.backgroundColor = myBackgroundColorWhite;
        [self.contentView addSubview:self.questionLab];
        [self.contentView addSubview:self.answerLab];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //cell 高度 100
    _questionLab.frame = CGRectMake(20, 10, self.contentView.bounds.size.width - 40, 30);
    _answerLab.frame = CGRectMake(20, 50, self.contentView.bounds.size.width - 40, 50);
    
}

-(UILabel *)questionLab {
    if (!_questionLab) {
        _questionLab = [UILabel new];
        _questionLab.font = [UIFont boldSystemFontOfSize:15];
        _questionLab.textColor = [UIColor blackColor];
    
        
//        _questionLab.backgroundColor = myBackgroundColorYellow;
    }
    return _questionLab;
}

-(UILabel *)answerLab {
    if (!_answerLab) {
        _answerLab = [UILabel new];
        _answerLab.font = [UIFont boldSystemFontOfSize:18];
        _answerLab.textColor = [UIColor blackColor];
        
        
//        _answerLab.backgroundColor = myBackgroundColorBlue;
    }
    return _answerLab;
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
