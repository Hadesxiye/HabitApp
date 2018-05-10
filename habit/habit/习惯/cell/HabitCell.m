//
//  HabitCell.m
//  habit
//
//  Created by 王浩祯 on 2018/3/21.
//  Copyright © 2018年 王浩祯. All rights reserved.
//

#import "HabitCell.h"

@implementation HabitCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.frame = self.bounds;
        
        self.backgroundImageView.userInteractionEnabled = YES;
        [self.backgroundImageView addSubview:self.notDoAmountLab];
        [self.backgroundImageView addSubview:self.habitNameLab];
        [self.backgroundImageView addSubview:self.didAmountLab];
        [self.backgroundImageView addSubview:self.addBtn];
        [self.backgroundImageView addSubview:self.minBtn];
        [self.backgroundImageView addSubview:self.habitDetailBtn];
        [self.contentView addSubview:self.backgroundImageView];
        
   
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //cell 高度 60
    _minBtn.frame = CGRectMake(0, 0, SC_WIDTH/5, 60);
    _addBtn.frame = CGRectMake(SC_WIDTH/5 * 4, 0, SC_WIDTH/5, 60);
    _notDoAmountLab.frame = CGRectMake(SC_WIDTH/5 , 30, SC_WIDTH/5, 30);
    _didAmountLab.frame = CGRectMake(SC_WIDTH/5 * 3, 30, SC_WIDTH/5, 30);
    _backgroundImageView.frame = CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
    _habitNameLab.frame = CGRectMake(SC_WIDTH/5 , 0, SC_WIDTH/5 * 3, 30);
    _habitDetailBtn.frame = CGRectMake( SC_WIDTH/5 , 0, SC_WIDTH/5 * 3, 60);
   
}

-(UILabel *)habitNameLab {
    if (!_habitNameLab) {
        _habitNameLab = [UILabel new];
        _habitNameLab.font = [UIFont boldSystemFontOfSize:15];
        _habitNameLab.textColor = [UIColor blackColor];
        _habitNameLab.frame = CGRectMake(60, 10, SC_WIDTH/3, 40);
        
        _habitNameLab.backgroundColor = [UIColor blueColor];
    }
    return _habitNameLab;
}

-(UILabel *)didAmountLab {
    if (!_didAmountLab) {
        _didAmountLab = [UILabel new];
        _didAmountLab.font = [UIFont boldSystemFontOfSize:15];
        _didAmountLab.textColor = [UIColor blackColor];
//        _didAmountLab.frame = CGRectMake(60, 10, SC_WIDTH/3, 40);
        _didAmountLab.backgroundColor = [UIColor orangeColor];
    }
    return _didAmountLab;
}

-(UILabel *)notDoAmountLab {
    if (!_notDoAmountLab) {
        _notDoAmountLab = [UILabel new];
        _notDoAmountLab.font = [UIFont boldSystemFontOfSize:15];
        _notDoAmountLab.textColor = [UIColor blackColor];
//        _notDoAmountLab.frame = CGRectMake(60, 10, SC_WIDTH/3, 40);
        
        _notDoAmountLab.backgroundColor = [UIColor yellowColor];
    }
    return _notDoAmountLab;
}

-(UIImageView *)backgroundImageView{
    if (!_backgroundImageView) {
        _backgroundImageView = [UIImageView new];
//        _backgroundImageView.frame = CGRectMake(10, 10, 40, 40);
        _backgroundImageView.backgroundColor = [UIColor redColor];
    }
    return _backgroundImageView;
}

-(UIButton *)addBtn{
    if (!_addBtn) {
        _addBtn = [UIButton new];
        [_addBtn setBackgroundImage:[UIImage imageNamed:@"plusIcon.png"] forState:UIControlStateNormal];
        _addBtn.backgroundColor = [UIColor purpleColor];
        
    }
    return _addBtn;
}

-(UIButton *)minBtn{
    if (!_minBtn) {
        _minBtn = [UIButton new];
        [_minBtn setBackgroundImage:[UIImage imageNamed:@"minusIcon.png"] forState:UIControlStateNormal];
        _minBtn.backgroundColor = [UIColor grayColor];
        
    }
    return _minBtn;
}

-(UIButton *)habitDetailBtn{
    if (!_habitDetailBtn) {
        _habitDetailBtn = [UIButton new];
        _habitDetailBtn.backgroundColor = [UIColor clearColor];
        
    }
    return _habitDetailBtn;
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
