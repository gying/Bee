//
//  CreatedPartyTableViewCell.m
//  Agree
//
//  Created by Agree on 15/7/16.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "CreatedPartyTableViewCell.h"
#define AgreeBlue [UIColor colorWithRed:82/255.0 green:213/255.0 blue:204/255.0 alpha:1.0]

@implementation CreatedPartyTableViewCell


- (void)awakeFromNib {
    // Initialization code
    
    [self.dateView.layer setCornerRadius:4];
    [self.dateView.layer setMasksToBounds:YES];
}

- (void)initRelationship: (NSNumber *)relationship {
    if (nil == relationship) {
        //未表态 - 还未进入
        [self.statusView setHidden:NO];
        
        [self.dateView setBackgroundColor:[UIColor clearColor]];
        [self.dateLabel setTextColor:AgreeBlue];
        [self.timeLabel setTextColor:AgreeBlue];
        
        [self.partyNameLabel setTextColor:[UIColor grayColor]];
        [self.partyAdreessLabel setTextColor:[UIColor lightGrayColor]];
        
        [self.inLabel setTextColor:[UIColor grayColor]];
    } else {
        switch ([relationship intValue]) {
            case 0: {
                //未表态
                [self.statusView setHidden:YES];
                
                [self.dateView setBackgroundColor:[UIColor clearColor]];
                [self.dateLabel setTextColor:AgreeBlue];
                [self.timeLabel setTextColor:AgreeBlue];
                
                [self.partyNameLabel setTextColor:[UIColor grayColor]];
                [self.partyAdreessLabel setTextColor:[UIColor lightGrayColor]];
                
                [self.inLabel setTextColor:[UIColor grayColor]];
            }
                break;
                
            case 1: {
                //同意
                [self.statusView setHidden:YES];
                
                [self.dateView setBackgroundColor:AgreeBlue];
                [self.dateLabel setTextColor:[UIColor whiteColor]];
                [self.timeLabel setTextColor:[UIColor whiteColor]];
                
                [self.partyNameLabel setTextColor:[UIColor darkGrayColor]];
                [self.partyAdreessLabel setTextColor:[UIColor darkGrayColor]];
                
                [self.inLabel setTextColor:AgreeBlue];
            }
                break;
                
            case 2: {
                //拒绝
                [self.statusView setHidden:YES];
                
                [self.dateView setBackgroundColor:[UIColor clearColor]];
                [self.dateLabel setTextColor:AgreeBlue];
                [self.timeLabel setTextColor:AgreeBlue];
                
                [self.partyNameLabel setTextColor:[UIColor grayColor]];
                [self.partyAdreessLabel setTextColor:[UIColor lightGrayColor]];
                
                [self.inLabel setTextColor:[UIColor grayColor]];
            }
                break;
                
            default:
                break;
        }
    }
}

- (void)initWithPayType: (Model_Party *)party {
    //开始分析付款状态
    
    //1.等待结账(适用于AA)
    //2.等待付款(使用于AA与预付款)
    //3.已经完成付款
    
    //4.已完成结账工作(需要在接口端进行判断 或者 增加字段属性)
    
    //首先先确定聚会支付类型
    switch (party.pay_type.intValue) {
        case 1: {
            //请客
            //请客则直接显示为已完成
            
            [self.statusView setHidden:YES];
            
            [self.dateView setBackgroundColor:AgreeBlue];
            [self.dateLabel setTextColor:[UIColor whiteColor]];
            [self.timeLabel setTextColor:[UIColor whiteColor]];
            
            [self.partyNameLabel setTextColor:[UIColor darkGrayColor]];
            [self.partyAdreessLabel setTextColor:[UIColor darkGrayColor]];
            
            [self.inLabel setTextColor:AgreeBlue];
            
            [self.peopleCountLabel setText:@"已完成"];
        }
            break;
            
        case 2: {
            //AA
            if (!party.pay_amount) {
                //如果付款项为空或者0 则代表还未结账
                [self.statusView setHidden:YES];
                
                [self.dateView setBackgroundColor:[UIColor clearColor]];
                [self.dateLabel setTextColor:AgreeBlue];
                [self.timeLabel setTextColor:AgreeBlue];
                
                [self.partyNameLabel setTextColor:[UIColor grayColor]];
                [self.partyAdreessLabel setTextColor:[UIColor lightGrayColor]];
                
                [self.inLabel setTextColor:[UIColor grayColor]];
                
                [self.peopleCountLabel setText:@"等待结账"];
                
            } else {
                if (party.user_pay_type && 0 != party.user_pay_type.intValue && 1 != party.user_pay_type.intValue) {
                    //已付款
                    [self.statusView setHidden:YES];
                    
                    [self.dateView setBackgroundColor:AgreeBlue];
                    [self.dateLabel setTextColor:[UIColor whiteColor]];
                    [self.timeLabel setTextColor:[UIColor whiteColor]];
                    
                    [self.partyNameLabel setTextColor:[UIColor darkGrayColor]];
                    [self.partyAdreessLabel setTextColor:[UIColor darkGrayColor]];
                    
                    [self.inLabel setTextColor:AgreeBlue];
                    
                    [self.peopleCountLabel setText:@"已付款"];
                    
                } else {
                    //等待付款中
                    [self.statusView setHidden:NO];
                    
                    [self.dateView setBackgroundColor:[UIColor clearColor]];
                    [self.dateLabel setTextColor:AgreeBlue];
                    [self.timeLabel setTextColor:AgreeBlue];
                    
                    [self.partyNameLabel setTextColor:[UIColor grayColor]];
                    [self.partyAdreessLabel setTextColor:[UIColor lightGrayColor]];
                    
                    [self.inLabel setTextColor:[UIColor grayColor]];
                    
                    [self.peopleCountLabel setText:@"等待付款"];
                }
            }
        }
            
            break;
        case 3: {
            //预付
            if (party.user_pay_type && 0 != party.user_pay_type.intValue && 1 != party.user_pay_type.intValue) {
                //已付款
                [self.statusView setHidden:YES];
                
                [self.dateView setBackgroundColor:AgreeBlue];
                [self.dateLabel setTextColor:[UIColor whiteColor]];
                [self.timeLabel setTextColor:[UIColor whiteColor]];
                
                [self.partyNameLabel setTextColor:[UIColor darkGrayColor]];
                [self.partyAdreessLabel setTextColor:[UIColor darkGrayColor]];
                
                [self.inLabel setTextColor:AgreeBlue];
                
                [self.peopleCountLabel setText:@"已付款"];
                
            } else {
                //等待付款中
                [self.statusView setHidden:NO];
                
                [self.dateView setBackgroundColor:[UIColor clearColor]];
                [self.dateLabel setTextColor:AgreeBlue];
                [self.timeLabel setTextColor:AgreeBlue];
                
                [self.partyNameLabel setTextColor:[UIColor grayColor]];
                [self.partyAdreessLabel setTextColor:[UIColor lightGrayColor]];
                
                [self.inLabel setTextColor:[UIColor grayColor]];
                [self.peopleCountLabel setText:@"等待付款"];
            }
        }
            
            break;
        default: {
            //未指定,则直接显示完成,与请客类似
            [self.statusView setHidden:YES];
            
            [self.dateView setBackgroundColor:AgreeBlue];
            [self.dateLabel setTextColor:[UIColor whiteColor]];
            [self.timeLabel setTextColor:[UIColor whiteColor]];
            
            [self.partyNameLabel setTextColor:[UIColor darkGrayColor]];
            [self.partyAdreessLabel setTextColor:[UIColor darkGrayColor]];
            
            [self.inLabel setTextColor:AgreeBlue];
            
            [self.peopleCountLabel setText:@"已完成"];
            
        }
            break;
    }
}

- (void)initWithParty: (Model_Party *)party {
    [self.statusView.layer setCornerRadius:self.statusView.frame.size.height/2];
    [self.statusView.layer setMasksToBounds:YES];
    
    [self initWithPayType:party];
//    [self initRelationship:party.relationship];
    
    [self.partyNameLabel setText:party.name];
    [self.partyAdreessLabel setText:party.location];
    
    NSDate *beginDate = party.begin_time;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"M月d日"];
    [self.dateLabel setText:[dateFormatter stringFromDate:beginDate]];
    
    [self.peopleCountLabel setFont:[UIFont systemFontOfSize:11]];
    [self.peopleCountLabel setTextColor:[UIColor lightGrayColor]];
    
//    if (![party.inNum isKindOfClass:[NSNull class]]) {
//        [self.peopleCountLabel setText:[NSString stringWithFormat:@"%d",[party.inNum intValue]]];
//    } else {
//        party.inNum = [NSNumber numberWithInt:0];
//        [self.peopleCountLabel setText:@"0"];
//    }
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
    [timeFormatter setDateFormat:@"k:ss"];
    [self.timeLabel setText:[timeFormatter stringFromDate:beginDate]];
    
    switch (party.pay_type.integerValue) {
        case 0: {
            //未指定
        }
            break;
        case 1: {
            self.inLabel.text = @"请客";
        }
            break;
        case 2: {
            self.inLabel.text = @"AA制";
        }
            break;
        case 3: {
            self.inLabel.text = @"预付款";
        }
            break;
        default:
            break;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:animated];

    // Configure the view for the selected state
}

@end
