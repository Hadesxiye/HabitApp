//
//  HabitNameCell.m
//  habit
//
//  Created by 王浩祯 on 2018/3/23.
//  Copyright © 2018年 王浩祯. All rights reserved.
//

#import "HabitNameCell.h"

@implementation HabitNameCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.frame = self.bounds;
        self.contentView.backgroundColor = myBackgroundColorWhite;
        [self.habitNameField addTarget:self action:@selector(textfieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];

        [self.contentView addSubview:self.habitNameField];
        
    }
    return self;
}
#pragma mark - private method
- (void)textfieldTextDidChange:(UITextField *)textField
{
    self.block(self.habitNameField.text);
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.habitNameField becomeFirstResponder];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    //cell 高度 60
    _habitNameField.frame = CGRectMake(20, 10, self.contentView.bounds.size.width - 40, 50);
   
    
}

-(UITextField *)habitNameField {
    if (!_habitNameField) {
        _habitNameField = [UITextField new];
        _habitNameField.font = [UIFont boldSystemFontOfSize:20];
        _habitNameField.textColor = [UIColor blackColor];
        _habitNameField.placeholder = @"说出你的愿望";
        
        _habitNameField.backgroundColor = myBackgroundColorPurple;
    }
    return _habitNameField;
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
