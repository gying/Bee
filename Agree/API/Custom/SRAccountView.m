//
//  SRAccountView.m
//  Agree
//
//  Created by G4ddle on 15/3/8.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "SRAccountView.h"
#import "UIImageView+WebCache.h"
#import <SVProgressHUD.h>
#import "MJExtension.h"
#import <AddressBook/AddressBook.h>
#import "UserChatViewController.h"

#import "AppDelegate.h"
#import "SRImageManager.h"


#define AgreeBlue [UIColor colorWithRed:82/255.0 green:213/255.0 blue:204/255.0 alpha:1.0]

#define firstRow    390
#define secondRow   490
#define thirdRow    550


@implementation SRAccountView {
    SRNet_Manager *_netManager;
    Model_User *_user;
}


- (id)init {
    
    self.msgView = [[UIView alloc] initWithFrame:[[[[UIApplication sharedApplication] delegate] window] frame]];
    self.msgView.center = [[[[UIApplication sharedApplication] delegate] window] center];
    
//    [self.msgView setBackgroundColor:[UIColor blackColor]];

    UIView *backView = [[UIView alloc] initWithFrame:self.msgView.frame];
    [backView setAlpha:0.95];
    

    [backView setBackgroundColor:[UIColor blackColor]];
    [self.msgView addSubview:backView];
    
    self.backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.backButton setFrame:self.msgView.frame];
    [self.backButton addTarget:self action:@selector(pressedTheBackButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.msgView addSubview:self.backButton];
//    [self.msgView setAlpha:0.9];
//    [self.msgView.layer setCornerRadius:3];
    
    
    //设置头像
    self.avatarButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    [self.avatarButton setBackgroundImage:[UIImage imageNamed:@"agree_user_setting_avatar_backgroup"] forState:UIControlStateNormal];
    [self.avatarButton setFrame:CGRectMake(0, 0, 99, 99)];
    [self.avatarButton addTarget:self action:@selector(pressedTheAvatarButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.avatarButton setBackgroundColor:[UIColor clearColor]];
    [self.avatarButton.layer setCornerRadius:self.avatarButton.frame.size.height/2];
    [self.avatarButton.layer setBorderColor:AgreeBlue.CGColor];
    [self.avatarButton.layer setBorderWidth:1.5f];
    [self.avatarButton setCenter:CGPointMake(self.msgView.frame.size.width/2, 190)];
    
    self.avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 90, 90)];
    [self.avatarImageView setCenter:CGPointMake(self.avatarButton.frame.size.width/2, self.avatarButton.frame.size.height/2)];
    [self.avatarImageView.layer setCornerRadius:self.avatarImageView.frame.size.height/2];
    [self.avatarImageView.layer setMasksToBounds:YES];
    [self.avatarImageView setBackgroundColor:[UIColor grayColor]];
    [self.avatarButton addSubview:self.avatarImageView];

    
    [self.msgView addSubview:self.avatarButton];
    
    
    self.nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 260, 40)];
//    [self.nicknameLabel setFrame:];
//    [self.nicknameLabel setBackgroundColor:[UIColor lightGrayColor]];
    [self.nicknameLabel setTextAlignment:NSTextAlignmentCenter];
    [self.nicknameLabel setCenter:CGPointMake(self.msgView.frame.size.width/2, 285)];
    [self.nicknameLabel setTextColor:[UIColor whiteColor]];
    [self.nicknameLabel setFont:[UIFont fontWithName:@"STHeitiSC-Light" size:20.0f]];
    [self.msgView addSubview:self.nicknameLabel];
    
    self.phoneNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 260, 20)];
//    [self.phoneNumLabel setBackgroundColor:[UIColor lightGrayColor]];
    [self.phoneNumLabel setTextAlignment:NSTextAlignmentCenter];
    [self.phoneNumLabel setCenter:CGPointMake(self.msgView.frame.size.width/2, 315)];
    [self.phoneNumLabel setTextColor:[UIColor whiteColor]];
    [self.msgView addSubview:self.phoneNumLabel];
    
    
    //拨打电话
    self.callButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.callButton setBackgroundColor:[UIColor clearColor]];
    [self.callButton setFrame:CGRectMake(0, 0, 70, 70)];
    [self.callButton.layer setCornerRadius:self.callButton.frame.size.height/2];
    [self.callButton setCenter:CGPointMake(self.msgView.frame.size.width/2 - 100, firstRow)];
    [self.callButton setBackgroundImage:[UIImage imageNamed:@"agree_phone_icon"] forState:UIControlStateNormal];
    [self.callButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.callButton.layer setBorderWidth:1.0f];
    [self.callButton setTag:1];
    [self.callButton addTarget:self action:@selector(pressedTheButton:) forControlEvents:UIControlEventTouchUpInside];
//    [self.callButton.layer setMasksToBounds:YES];
    [self.msgView addSubview:self.callButton];

    
    self.callLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 20)];
    [self.callLabel setTextAlignment:NSTextAlignmentCenter];
    [self.callLabel setText:@"拨电话"];
    [self.callLabel setFont:[UIFont systemFontOfSize:11.0]];
    [self.callLabel setCenter:CGPointMake(self.callButton.center.x, self.callButton.center.y + 48)];
    [self.callLabel setTextColor:[UIColor lightGrayColor]];
    [self.msgView addSubview:self.callLabel];
    
    
    //发短信
    self.msgButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.msgButton setBackgroundColor:[UIColor clearColor]];
    [self.msgButton setFrame:CGRectMake(0, 0, 70, 70)];
    [self.msgButton.layer setCornerRadius:self.msgButton.frame.size.height/2];
    [self.msgButton setCenter:CGPointMake(self.msgView.frame.size.width/2, firstRow)];
    [self.msgButton setBackgroundImage:[UIImage imageNamed:@"agree_send_message_icon"] forState:UIControlStateNormal];
    [self.msgButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.msgButton.layer setBorderWidth:1.0f];
    //    [self.callButton.layer setMasksToBounds:YES];
    [self.msgButton setTag:2];
    [self.msgButton addTarget:self action:@selector(pressedTheButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.msgView addSubview:self.msgButton];
    
    self.msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 20)];
    [self.msgLabel setTextAlignment:NSTextAlignmentCenter];
    [self.msgLabel setText:@"发信息"];
    [self.msgLabel setFont:[UIFont systemFontOfSize:11.0]];
    [self.msgLabel setCenter:CGPointMake(self.msgButton.center.x, self.msgButton.center.y + 48)];
    [self.msgLabel setTextColor:[UIColor lightGrayColor]];
    [self.msgView addSubview:self.msgLabel];
    
    
    //保存到通讯录
    self.abButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.abButton setBackgroundColor:[UIColor clearColor]];
    [self.abButton setFrame:CGRectMake(0, 0, 70, 70)];
    [self.abButton.layer setCornerRadius:self.abButton.frame.size.height/2];
    [self.abButton setCenter:CGPointMake(self.msgView.frame.size.width/2 + 100, firstRow)];
    [self.abButton setBackgroundImage:[UIImage imageNamed:@"agree_save_book_icon"] forState:UIControlStateNormal];
    [self.abButton.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self.abButton.layer setBorderWidth:1.0f];
    [self.abButton setTag:3];
    [self.abButton addTarget:self action:@selector(pressedTheButton:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.callButton.layer setMasksToBounds:YES];
    [self.msgView addSubview:self.abButton];
    
    self.abllLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 20)];
    [self.abllLabel setTextAlignment:NSTextAlignmentCenter];
    [self.abllLabel setText:@"保存到通讯录"];
    [self.abllLabel setFont:[UIFont systemFontOfSize:11.0]];
    [self.abllLabel setCenter:CGPointMake(self.abButton.center.x, self.abButton.center.y + 48)];
    [self.abllLabel setTextColor:[UIColor lightGrayColor]];
    [self.msgView addSubview:self.abllLabel];
    
    
    //添加好友
    self.addFriendButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.addFriendButton setBackgroundColor:[UIColor clearColor]];
    [self.addFriendButton setFrame:CGRectMake(0, 0, 70, 70)];
    [self.addFriendButton.layer setCornerRadius:self.addFriendButton.frame.size.height/2];
    [self.addFriendButton setCenter:CGPointMake(self.msgView.frame.size.width/2, secondRow)];
    [self.addFriendButton.layer setBorderColor:AgreeBlue.CGColor];
    [self.addFriendButton.layer setBorderWidth:1.0f];
    [self.addFriendButton setTag:4];
    [self.addFriendButton addTarget:self action:@selector(pressedTheButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.msgView addSubview:self.addFriendButton];
    
    self.addFriendLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 20)];
    [self.addFriendLabel setTextAlignment:NSTextAlignmentCenter];
    [self.addFriendLabel setText:@"添加好友"];
    [self.addFriendLabel setFont:[UIFont systemFontOfSize:11.0]];
    [self.addFriendLabel setCenter:CGPointMake(self.addFriendButton.center.x, self.addFriendButton.center.y + 48)];
    [self.addFriendLabel setTextColor:[UIColor whiteColor]];
    [self.msgView addSubview:self.addFriendLabel];
    
    
    //删除好友
    self.delFriendButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.delFriendButton setBackgroundColor:[UIColor clearColor]];
    [self.delFriendButton setFrame:CGRectMake(0, 0, 70, 70)];
    [self.delFriendButton.layer setCornerRadius:self.delFriendButton.frame.size.height/2];
    [self.delFriendButton setCenter:CGPointMake(self.msgView.frame.size.width/2 - 60, secondRow)];
    [self.delFriendButton.layer setBorderColor:AgreeBlue.CGColor];
    [self.delFriendButton.layer setBorderWidth:1.0f];
    
    [self.delFriendButton setTag:5];
    [self.delFriendButton addTarget:self action:@selector(pressedTheButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.msgView addSubview:self.delFriendButton];
    
    self.delFriendLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 20)];
    [self.delFriendLabel setTextAlignment:NSTextAlignmentCenter];
    [self.delFriendLabel setText:@"删除好友"];
    [self.delFriendLabel setFont:[UIFont systemFontOfSize:11.0]];
    [self.delFriendLabel setCenter:CGPointMake(self.delFriendButton.center.x, self.delFriendButton.center.y + 48)];
    [self.delFriendLabel setTextColor:[UIColor whiteColor]];
    [self.msgView addSubview:self.delFriendLabel];
    
    
    //私聊
    self.talkFriendButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.talkFriendButton setBackgroundColor:[UIColor clearColor]];
    [self.talkFriendButton setFrame:CGRectMake(0, 0, 70, 70)];
    [self.talkFriendButton.layer setCornerRadius:self.talkFriendButton.frame.size.height/2];
    [self.talkFriendButton setCenter:CGPointMake(self.msgView.frame.size.width/2 + 60, secondRow)];
    [self.talkFriendButton.layer setBorderColor:AgreeBlue.CGColor];
    [self.talkFriendButton.layer setBorderWidth:1.0f];
    [self.talkFriendButton setTag:6];
    [self.talkFriendButton addTarget:self action:@selector(pressedTheButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.msgView addSubview:self.talkFriendButton];
    
    self.talkFriendLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 20)];
    [self.talkFriendLabel setTextAlignment:NSTextAlignmentCenter];
    [self.talkFriendLabel setText:@"私聊"];
    [self.talkFriendLabel setFont:[UIFont systemFontOfSize:11.0]];
    [self.talkFriendLabel setCenter:CGPointMake(self.talkFriendButton.center.x, self.talkFriendButton.center.y + 48)];
    [self.talkFriendLabel setTextColor:[UIColor whiteColor]];
    [self.msgView addSubview:self.talkFriendLabel];
    
    
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self.msgView];
    
    [self.backButton setHidden:YES];
    [self.msgView setHidden:YES];
    
    return [super init];
}

- (void)loadWithUser:(Model_User *)user withGroup: (Model_Group *)group {
    self.nicknameLabel.text = user.nickname;
    
//    [self.avatarImageView sd_setImageWithURL:[SRImageManager avatarImageFromTXYFieldID:user.avatar_path]];
    
    //下载图片
    NSURL *imageUrl = [SRImageManager avatarImageFromTXYFieldID:user.avatar_path];
//    NSString * urlstr = [imageUrl absoluteString];
//    
//    [[TXYDownloader sharedInstanceWithPersistenceId:nil]download:urlstr target:self.avatarImageView succBlock:^(NSString *url, NSData *data, NSDictionary *info) {
//        [self.avatarImageView setImage:[UIImage imageWithContentsOfFile:[info objectForKey:@"filePath"]]];
//    } failBlock:nil progressBlock:nil param:nil];
    
    [self.avatarImageView sd_setImageWithURL:imageUrl];
    
    
    [self.callButton setHidden:YES];
    [self.callLabel setHidden:YES];
    [self.msgButton setHidden:YES];
    [self.msgLabel setHidden:YES];
    [self.abButton setHidden:YES];
    [self.abllLabel setHidden:YES];
    [self.addFriendButton setHidden:YES];
    [self.addFriendLabel setHidden:YES];
    [self.delFriendButton setHidden:YES];
    [self.delFriendLabel setHidden:YES];
    [self.talkFriendButton setHidden:YES];
    [self.talkFriendLabel setHidden:YES];
    
    _user = user;
    
    if (group) {
        //从小组进入,则需要查看与小组的关系和用户本身的关系
        if (!_netManager) {
            _netManager = [[SRNet_Manager alloc] initWithDelegate:self];
        }
        Model_user_user *relationship = [[Model_user_user alloc] init];
        [relationship setFk_user_from:[Model_User loadFromUserDefaults].pk_user];
        [relationship setFk_user_to:user.pk_user];
        [_netManager checkRelation:relationship];
        
    } else {
        //如果不是从小组进入,则只查看用户本身的关系
        //读取用户关系
        if (!_netManager) {
            _netManager = [[SRNet_Manager alloc] initWithDelegate:self];
        }
        Model_user_user *relationship = [[Model_user_user alloc] init];
        [relationship setFk_user_from:[Model_User loadFromUserDefaults].pk_user];
        [relationship setFk_user_to:user.pk_user];
        [_netManager checkRelation:relationship];
    }
}

- (void)pressedTheBackButton: (id)sender {
    [self.backButton setHidden:YES];
    [self.msgView setHidden:YES];
}

- (void)pressedTheAvatarButton: (id)sender {
    NSLog(@"点击头像图片");
}

- (BOOL)show {
    if (![_user.pk_user isEqual:[Model_User loadFromUserDefaults].pk_user]) {
        [self.backButton setHidden:NO];
        [self.msgView setHidden:NO];
        
        return false;
    }
    return TRUE;
}

- (void)phoneNumToShow {
    if (_user.phone) {
        //拥有号码字段
        if (_user.relationship) {
            //拥有关系
            //如果存在关系
            switch (_user.relationship.intValue) {
                case 1: {
                    //等待对方通过好友关系
                    [self hiddenPhoneNum:YES];
                    [self hiddenFriendHandleButton:YES];
                    [self.addFriendLabel setText:@"等待对方接受"];
                }
                    break;
                case 2: {
                    //等待接受好友关系
                    [self hiddenPhoneNum:YES];
                    [self hiddenFriendHandleButton:YES];
                    [self.addFriendLabel setText:@"同意好友请求"];
                }
                    break;
                case 3: {
                    //已经成为好友
                    [self.phoneNumLabel setText:_user.phone];
                    
                    [self hiddenPhoneNum:NO];
                    [self hiddenFriendHandleButton:NO];
                }
                    break;
                case 4: {
                    //?
                    [self hiddenPhoneNum:YES];
                }
                    break;
                default:
                    [self hiddenPhoneNum:YES];
                    break;
            }
        } else {
            //没有关系
            //无关系或者关系未认证,则隐藏号码字段
            [self hiddenPhoneNum:YES];
            
        }
        
    } else {
        //用户无号码字段
        [self hiddenPhoneNum:YES];
        
        if (_user.relationship) {
            //如果存在关系
            switch (_user.relationship.intValue) {
                case 1: {
                    //等待对方通过好友关系
                    [self hiddenFriendHandleButton:YES];
                    [self.addFriendLabel setText:@"等待对方接受"];
                }
                    break;
                case 2: {
                    //等待接受好友关系
                    [self hiddenFriendHandleButton:YES];
                    [self.addFriendLabel setText:@"同意好友请求"];
                }
                    break;
                case 3: {
                    //已经成为好友
                    [self hiddenFriendHandleButton:NO];
                }
                    break;
                case 4: {
                    //?
                }
                    break;
                default:
                    break;
            }
        } else {
            //没有关系,显示加好友按钮
//            [self hiddenPhoneNum:YES];
            [self hiddenFriendHandleButton:YES];
        }
    }
}

- (void)hiddenPhoneNum:(BOOL)hidden {
    [self.callButton setHidden:hidden];
    [self.callLabel setHidden:hidden];
    [self.msgButton setHidden:hidden];
    [self.msgLabel setHidden:hidden];
    [self.abButton setHidden:hidden];
    [self.abllLabel setHidden:hidden];
    
    [self.phoneNumLabel setHidden:hidden];
    
    if (hidden) {
        [self changeFriendHandleRow:secondRow];
    }else {
        [self changeFriendHandleRow:secondRow];
    }
}

- (void)hiddenFriendHandleButton: (BOOL)hidden {
    [self.delFriendButton setHidden:hidden];
    [self.delFriendLabel setHidden:hidden];
    [self.talkFriendButton setHidden:hidden];
    [self.talkFriendLabel setHidden:hidden];
    
    [self.addFriendButton setHidden:!hidden];
    [self.addFriendLabel setHidden:!hidden];
}

- (void)changeFriendHandleRow: (float)row {
    
    [self.addFriendButton setCenter:CGPointMake(self.msgView.frame.size.width/2, row)];
    [self.addFriendLabel setCenter:CGPointMake(self.addFriendButton.center.x, self.addFriendButton.center.y + 48)];
    
    [self.delFriendButton setCenter:CGPointMake(self.msgView.frame.size.width/2 - 60, row)];
    [self.delFriendLabel setCenter:CGPointMake(self.delFriendButton.center.x, self.delFriendButton.center.y + 48)];
    [self.talkFriendButton setCenter:CGPointMake(self.msgView.frame.size.width/2 + 60, row)];
    [self.talkFriendLabel setCenter:CGPointMake(self.talkFriendButton.center.x, self.talkFriendButton.center.y + 48)];

}

- (void)pressedTheButton:(UIButton *)sender {
    switch (sender.tag) {
        case 1: {
            //打电话
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", _user.phone]]];
        }
            break;
        case 2: {
            //发信息
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@", _user.phone]]];
        }
            break;
        case 3: {
            //保存通讯录
            
            //添加到通讯录
            ABAddressBookRef iPhoneAddressBook = ABAddressBookCreateWithOptions(nil, nil);
            ABRecordRef newPerson = ABPersonCreate();
            CFErrorRef error = NULL;
            //名字
            ABRecordSetValue(newPerson, kABPersonFirstNameProperty, (__bridge CFTypeRef)(_user.nickname), &error);
//            ABRecordSetValue(newPerson, kABPersonLastNameProperty, @"bibibibi", &error);
            
            //手机号码
            ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
            ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFTypeRef)(_user.phone), kABPersonPhoneMobileLabel, NULL);

            ABRecordSetValue(newPerson, kABPersonPhoneProperty, multiPhone,&error);
            CFRelease(multiPhone);
            
                
            ABAddressBookAddRecord(iPhoneAddressBook, newPerson, &error);
            ABAddressBookSave(iPhoneAddressBook, &error);
            if (error != NULL)
            {
                NSLog(@"Danger Will Robinson! Danger!");
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通知" message:@"联系人保存成功" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
            [alert show];
            

        }
            break;
        case 4: {
            //添加好友 or 等待验证 or 通过好友
            
            if (_user.relationship.integerValue) {
                //好友关系
                switch (_user.relationship.integerValue) {
                    case 1: {
                        //等待验证
                        
                    }
                        break;
                    case 2: {
                        //同意关系
                        Model_user_user *userRelation = [[Model_user_user alloc] init];
                        userRelation.fk_user_from = [Model_User loadFromUserDefaults].pk_user;
                        userRelation.fk_user_to = _user.pk_user;
                        [_netManager becomeFriend:userRelation];
                        
                        [self updateRelation];
                    }
                        break;
                    
                    default:
                        break;
                }
            } else {
                //添加为好友
                Model_user_user *userRelation = [[Model_user_user alloc] init];
                [userRelation setFk_user_from:[Model_User loadFromUserDefaults].pk_user];
                [userRelation setFk_user_to:_user.pk_user];
                [userRelation setRelationship:@1];
                [userRelation setStatus:@1];
                [_netManager addFriend:userRelation];
            }
        }
            break;
        case 5: {
            //删除好友
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"您是否确定要删除该好友?"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil];
            [alert show];
        }
            break;
        case 6: {
            //私聊
            if (self.rootController) {
                
                UIViewController *firstController = [self.rootController.navigationController.viewControllers firstObject];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self pressedTheBackButton:nil];
                    
                    if ([firstController isKindOfClass:[ContactsTableViewController class]]) {
                        
                    } else {
                        [self.rootController.navigationController popToRootViewControllerAnimated:YES];
                    }
                });
                
                
                
                if ([firstController isKindOfClass:[ContactsTableViewController class]]) {
                    [self.rootController.navigationController popToRootViewControllerAnimated:YES];
                    [(ContactsTableViewController *)firstController intoMessage:_user];
                } else {
                    [self.rootController.tabBarController setSelectedIndex:2];
                    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    UINavigationController *nav = [delegate.rootController.viewControllers objectAtIndex:2];
                    [delegate.rootController setSelectedIndex:2];
                    ContactsTableViewController *showController = [[nav viewControllers] firstObject];
                    
                    [showController intoMessage: _user];
                }
                
                
            }
        }
            break;
        default:
            break;
    }
}

- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: {   //取消
            
        }
            break;
        case 1: {   //确定删除
            if (!_netManager) {
                _netManager = [[SRNet_Manager alloc] initWithDelegate:self];
            }
            
            Model_user_user *sendRealtion = [[Model_user_user alloc] init];
            [sendRealtion setFk_user_from:[Model_User loadFromUserDefaults].pk_user];
            [sendRealtion setFk_user_to:_user.pk_user];
            [_netManager removeFriend:sendRealtion];
            
            [self updateRelation];
        }
            break;
        default:
            break;
    }
}

- (void)updateRelation {
    NSNumber *updateValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"contact_update"];
    updateValue = [NSNumber numberWithInt:updateValue.intValue + 1];
    [[NSUserDefaults standardUserDefaults] setObject:updateValue forKey:@"contact_update"];
}

- (void)interfaceReturnDataSuccess:(id)jsonDic with:(int)interfaceType {
    
    switch (interfaceType) {
        case kBecomeFriend: {
            if (jsonDic) {
                _user.relationship = @3;
                [self phoneNumToShow];
            } else {
                [self hiddenPhoneNum:YES];
                [self hiddenFriendHandleButton:YES];
            }
        }
            break;
            
        case kAddFriend: {
            if (jsonDic) {
                _user = [[Model_User objectArrayWithKeyValuesArray:jsonDic] objectAtIndex:0];
                [self phoneNumToShow];
                [self updateRelation];
            } else {
                [self hiddenPhoneNum:YES];
                [self hiddenFriendHandleButton:YES];
            }
        }
            break;
        case kRemoveFriend: {
            if (jsonDic) {
                [self hiddenPhoneNum:YES];
                [self hiddenFriendHandleButton:YES];
                [self updateRelation];
            } else {
                [self hiddenPhoneNum:YES];
                [self hiddenFriendHandleButton:YES];
            }
        }
            break;
        case kCheckRelation: {
            if (jsonDic) {
                _user = [[Model_User objectArrayWithKeyValuesArray:jsonDic] objectAtIndex:0];
                [self phoneNumToShow];
            } else {
                [self hiddenPhoneNum:YES];
                [self hiddenFriendHandleButton:YES];
            }
        }
            break;
        default:
            break;
    }
    
    [SVProgressHUD dismiss];
}

- (void)interfaceReturnDataError:(int)interfaceType {
    [SVProgressHUD dismiss];
}

@end
