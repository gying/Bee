//
//  GroupSettingUITableViewCell.m
//  Agree
//
//  Created by Agree on 15/8/11.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "GroupSettingUITableViewCell.h"

@implementation GroupSettingUITableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.detailTextLabel.text = @"小组名称";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
