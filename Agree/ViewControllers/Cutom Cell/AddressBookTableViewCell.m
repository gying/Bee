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
    SRNet_Manager *_netManager;
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
        NSURL *imageUrl = [SRImageManager miniAvatarImageFromTXYFieldID:adPeople.userInfo.avatar_path];
        NSString * urlstr = [imageUrl absoluteString];
        
        [[TXYDownloader sharedInstanceWithPersistenceId:nil]download:urlstr target:self.avatarImageView succBlock:^(NSString *url, NSData *data, NSDictionary *info) {
            [self.avatarImageView setImage:[UIImage imageWithContentsOfFile:[info objectForKey:@"filePath"]]];
        } failBlock:nil progressBlock:nil param:nil];

//        [self.avatarImageView sd_setImageWithURL:[SRImageManager miniAvatarImageFromTXYFieldID:adPeople.userInfo.avatar_path]];
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
        
        
//        [self.avatarImageView sd_setImageWithURL:[SRImageManager miniAvatarImageFromTXYFieldID:adPeople.userInfo.avatar_path]];
        //下载图片
        NSURL *imageUrl = [SRImageManager miniAvatarImageFromTXYFieldID:adPeople.userInfo.avatar_path];
        NSString * urlstr = [imageUrl absoluteString];
        
        [[TXYDownloader sharedInstanceWithPersistenceId:nil]download:urlstr target:self.avatarImageView succBlock:^(NSString *url, NSData *data, NSDictionary *info) {
            [self.avatarImageView setImage:[UIImage imageWithContentsOfFile:[info objectForKey:@"filePath"]]];
        } failBlock:nil progressBlock:nil param:nil];
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
                    
                    if (!_netManager) {
                        _netManager = [[SRNet_Manager alloc] initWithDelegate:self];
                    }
                    
                    Model_user_user *userRelation = [[Model_user_user alloc] init];
                    userRelation.fk_user_from = [Model_User loadFromUserDefaults].pk_user;
                    userRelation.fk_user_to = _people.userInfo.pk_user;
                    [_netManager becomeFriend:userRelation];
                    
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
            if (!_netManager) {
                _netManager = [[SRNet_Manager alloc] initWithDelegate:self];
            }
            
            Model_user_user *userRelation = [[Model_user_user alloc] init];
            [userRelation setFk_user_from:[Model_User loadFromUserDefaults].pk_user];
            [userRelation setFk_user_to:_people.userInfo.pk_user];
            [userRelation setRelationship:@1];
            [userRelation setStatus:@1];
            [_netManager addFriend:userRelation];
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

- (void)interfaceReturnDataSuccess:(id)jsonDic with:(int)interfaceType {
    
    switch (interfaceType) {
        case kAddFriend: {
            //添加为好友
            [_people.userInfo setRelationship:@1];
            [self.sendButton setTitle:@"请求已发送" forState:UIControlStateNormal];
            
            [self updateRelation];
        }
            break;
        case kBecomeFriend: {
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
        }
            break;
        default:
            break;
    }
    [SVProgressHUD dismiss];
}

- (void)interfaceReturnDataError:(int)interfaceType {
    [SVProgressHUD showErrorWithStatus:@"网络错误"];
}

@end
