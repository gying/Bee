//
//  AddressBookTableViewCell.m
//  Agree
//
//  Created by G4ddle on 15/3/20.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "AddressBookTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "People.h"
#import <SVProgressHUD.h>
#import "SRImageManager.h"


@implementation AddressBookTableViewCell {
    People *_people;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initWithPeople: (People *)adPeople {
    [self.avatarImageView.layer setCornerRadius:self.avatarImageView.frame.size.height/2];
    [self.avatarImageView.layer setMasksToBounds:YES];
    
    self.avatarImageView.image = nil;
    
    _people = adPeople;
    
    if (nil == adPeople.userInfo) {
        //通讯录,而未加入必聚
        [self.nameLabel setHidden:NO];
        
        [self.nicknameLabel setHidden:YES];
        [self.addressBookNameLabel setHidden:YES];
        [self.sendButton setTitle:@"邀请加入" forState:UIControlStateNormal];
        
        [self.nameLabel setText:adPeople.name];
    } else if (nil == adPeople.name) {
        //必聚用户,未加入通讯录
        [self.nameLabel setHidden:NO];
        
        [self.nicknameLabel setHidden:YES];
        [self.addressBookNameLabel setHidden:YES];
        [self.nameLabel setText:adPeople.userInfo.nickname];
        
        //下载图片
        NSURL *imageUrl = [SRImageManager miniAvatarImageFromOSS:adPeople.userInfo.avatar_path];
        [self.avatarImageView sd_setImageWithURL:imageUrl];

        if (adPeople.userInfo.relationship) {
            switch (adPeople.userInfo.relationship.intValue) {
                case 1: {
                    //已经发送请求,等待对方同意
                    [self.sendButton setTitle:@"请求已发送" forState:UIControlStateNormal];
                }
                    break;
                case 2: {
                    //收到请求,等待自己同意
                    [self.sendButton setTitle:@"同意" forState:UIControlStateNormal];
                }
                    break;
                case 3: {
                    //已经成为好友
                    [self.sendButton setTitle:@"成为好友" forState:UIControlStateNormal];
                }
                    break;
                default:
                    break;
            }
        } else {
            [self.sendButton setTitle:@"加为好友" forState:UIControlStateNormal];
        }
        
    } else {
        [self.nameLabel setHidden:YES];
        
        [self.nicknameLabel setHidden:NO];
        [self.addressBookNameLabel setHidden:NO];
        
        if (adPeople.userInfo.relationship) {
            switch (adPeople.userInfo.relationship.intValue) {
                case 1: {
                    //已经发送请求,等待对方同意
                    [self.sendButton setTitle:@"请求已发送" forState:UIControlStateNormal];
                }
                    break;
                case 2: {
                    //收到请求,等待自己同意
                    [self.sendButton setTitle:@"同意" forState:UIControlStateNormal];
                }
                    break;
                case 3: {
                    //已经成为好友
                    [self.sendButton setTitle:@"成为好友" forState:UIControlStateNormal];
                }
                    break;
                default:
                    break;
            }
        } else {
            [self.sendButton setTitle:@"加为好友" forState:UIControlStateNormal];
        }
        
        
        [self.nicknameLabel setText:adPeople.userInfo.nickname];
        [self.addressBookNameLabel setText:[NSString stringWithFormat:@"通讯录名称: %@",adPeople.name]];

        //下载图片
        NSURL *imageUrl = [SRImageManager miniAvatarImageFromOSS:adPeople.userInfo.avatar_path];
        [self.avatarImageView sd_setImageWithURL:imageUrl];
    }
}


- (IBAction)pressedTheSendButton:(id)sender {
    if (_people.userInfo) {
        //必聚用户
        if (_people.userInfo.relationship) {
            switch (_people.userInfo.relationship.intValue) {
                case 1: {
                    //已经发送请求,等待对方同意
                    //等待
                    
                }
                    break;
                case 2: {
                    //收到请求,等待自己同意
                    //同意请求
                    [self.sendButton setEnabled:NO];

                    Model_user_user *userRelation = [[Model_user_user alloc] init];
                    userRelation.fk_user_from = [Model_User loadFromUserDefaults].pk_user;
                    userRelation.fk_user_to = _people.userInfo.pk_user;
                    [SRNet_Manager requestNetWithDic:[SRNet_Manager becomeFriendDic:userRelation]
                                            complete:^(NSString *msgString, id jsonDic, int interType, NSURLSessionDataTask *task) {
                                                switch (_people.userInfo.relationship.intValue) {
                                                    case 1: {
                                                        //已经发送请求,等待对方同意
                                                        //等待
                                                    }
                                                        break;
                                                    case 2: {
                                                        //收到请求,等待自己同意
                                                        //同意请求
                                                        [_people.userInfo setRelationship:@3];
                                                        [self.sendButton setTitle:@"成为好友" forState:UIControlStateNormal];
                                                        
                                                        [self updateRelation];
                                                    }
                                                        break;
                                                    case 3: {
                                                        //已经成为好友
                                                        //打开私聊界面
                                                    }
                                                        break;
                                                    default:
                                                        break;
                                                }
                                            } failure:^(NSError *error, NSURLSessionDataTask *task) {
                                                
                                            }];
                    
                }
                    break;
                case 3: {
                    //已经成为好友
                    //打开私聊界面
                }
                    break;
                default:
                    break;
            }
        } else {
            //添加为好友
            [self.sendButton setEnabled:NO];
            
            Model_user_user *userRelation = [[Model_user_user alloc] init];
            [userRelation setFk_user_from:[Model_User loadFromUserDefaults].pk_user];
            [userRelation setFk_user_to:_people.userInfo.pk_user];
            [userRelation setRelationship:@1];
            [userRelation setStatus:@1];
            
            [SRNet_Manager requestNetWithDic:[SRNet_Manager addFriendDic:userRelation]
                                    complete:^(NSString *msgString, id jsonDic, int interType, NSURLSessionDataTask *task) {
                                        //添加为好友
                                        [_people.userInfo setRelationship:@1];
                                        [self.sendButton setTitle:@"请求已发送" forState:UIControlStateNormal];
                                        
                                        [self updateRelation];
                                    } failure:^(NSError *error, NSURLSessionDataTask *task) {
                                        
                                    }];
        }
    } else {
        //通讯录,发短信邀请加入
        NSString *firstPhone = [_people.phoneAry firstObject];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@", firstPhone]]];
    }
}

- (void)updateRelation {
    NSNumber *updateValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"contact_update"];
    updateValue = [NSNumber numberWithInt:updateValue.intValue + 1];
    [[NSUserDefaults standardUserDefaults] setObject:updateValue forKey:@"contact_update"];
}

@end
