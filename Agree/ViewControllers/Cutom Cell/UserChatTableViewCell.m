//
//  UserChatTableViewCell.m
//  Agree
//
//  Created by G4ddle on 15/3/23.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "UserChatTableViewCell.h"
#import "SRTool.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"


#import "IEMMessageBody.h"
#import "EMTextMessageBody.h"
#import "EMImageMessageBody.h"

#import "EaseMob.h"
#import "SRImageManager.h"

@implementation UserChatTableViewCell {

    BOOL _isImageDataIsSelf;
    EModel_User_Chat *_chat;
}

- (void)awakeFromNib {
    // Initialization code
    
//#pragma mark -- 暂时设置CELL颜色为红色测试过后删除
//    self.backgroundColor = [UIColor redColor];
    
    [self.messageBackgroundButton_self canBecomeFirstResponder];
    
    
    
    [self.avatarButton.layer setCornerRadius:self.avatarButton.frame.size.width/2];
    [self.avatarButton.layer setMasksToBounds:YES];
    
    [self.avatarButton_self.layer setCornerRadius:self.avatarButton_self.frame.size.width/2];
    [self.avatarButton_self.layer setMasksToBounds:YES];
    
    [self.imageButton_self.layer setCornerRadius:3.0];
    [self.imageButton_self.layer setMasksToBounds:YES];
    
    [self.imageButton.layer setCornerRadius:3.0];
    [self.imageButton.layer setMasksToBounds:YES];
    
    
    UIImage *stretchableImage = [[UIImage imageNamed:@"MessageBackGround_Other"] resizableImageWithCapInsets:UIEdgeInsetsMake(13, 20, 6, 10) resizingMode:UIImageResizingModeStretch];
    [self.messageBackgroundButton setBackgroundImage:stretchableImage forState:UIControlStateNormal];
    
    UIImage *stretchableImage_self = [[UIImage imageNamed:@"MessageBackGround"] resizableImageWithCapInsets:UIEdgeInsetsMake(7, 10, 12, 20) resizingMode:UIImageResizingModeStretch];
    [self.messageBackgroundButton_self setBackgroundImage:stretchableImage_self forState:UIControlStateNormal];
}


- (void)initWithChat: (EModel_User_Chat *)message {
    
    _chat = message;
    
    ;
    
    //统一读取时间格式
    NSString *dateString;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    switch ([SRTool dateJudgeWithDate:[NSDate dateWithTimeIntervalSince1970:_chat.message.timestamp/1000]]) {
        case 1: {
            //今天
            [dateFormatter setDateFormat:@"aa\nh:mm"];
            
        }
            break;
        case 2: {
            //昨天
            [dateFormatter setDateFormat:@"昨天\nHH:mm"];
            
        }
            break;
        case 3: {
            //其他时间
            [dateFormatter setDateFormat:@"yy/M/d\nHH:mm"];
            
        }
            break;
        default: {
            [dateFormatter setDateFormat:@"yy/M/d\nHH:mm"];
        }
            break;
    }
    
    dateString = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:_chat.message.timestamp/1000]];
    
    id<IEMMessageBody> msgBody = _chat.message.messageBodies.firstObject;

    switch (msgBody.messageBodyType) {
        case eMessageBodyType_Text: {
            //文本
            if (_chat.sendFromSelf) {
                //自己发的信息
                //自己发言
                float conL = 0;
                if (message.cell_width) {
                    if (message.cell_width.doubleValue >= [[UIScreen mainScreen] bounds].size.width - 185) {
                        conL =  100.0;
                    } else {
                        conL = 100.0 + ([[UIScreen mainScreen] bounds].size.width - 185 - message.cell_width.doubleValue);
                    }
                }else {
                    conL =  100.0;
                }
                
                [self.selfViewConLeft setConstant:conL];
                [self setTalkingAccountType:1];
                self.chatMessageTextLabel_self.text = ((EMTextMessageBody *)msgBody).text;
                [self.chatDateLabel_self setText:dateString];
                
                
                [self.avatarButton_self sd_setBackgroundImageWithURL:[SRImageManager miniAvatarImageFromTXYFieldID:message.avatar_path_from] forState:UIControlStateNormal];
                
                

                
            } else {
                //他人发的信息
                float conR = 0;
                if (message.cell_width) {
                    if (message.cell_width.doubleValue >= [[UIScreen mainScreen] bounds].size.width - 132) {
                        conR =  42.0;
                    } else {
                        conR = 42.0 + ([[UIScreen mainScreen] bounds].size.width - 132 - message.cell_width.doubleValue);
                    }
                }else {
                    conR =  42.0;
                    
                }
                [self.otherViewConRight setConstant:conR];
                
                //他人发言
                [self setTalkingAccountType:2];
                [self.chatNicknameLabel setText:message.nickname_from];
                self.chatMessageTextLabel.text = ((EMTextMessageBody *)msgBody).text;
                [self.chatDateLabel setText:dateString];
                
                //处理头像信息
                [self.avatarButton sd_setBackgroundImageWithURL:[SRImageManager miniAvatarImageFromTXYFieldID:message.avatar_path_from] forState:UIControlStateNormal];
                
            }
        }
            break;
        case eMessageBodyType_Image: {
            EMImageMessageBody *body = ((EMImageMessageBody *)msgBody);
            //图片
            if (_chat.sendFromSelf) {
                //自己发的图片
                float conL =  [[UIScreen mainScreen] bounds].size.width - body.thumbnailSize.width/2 - 74.0;
                [self.selfViewConLeft setConstant:conL];

                [self setTalkingAccountType:3];
                _isImageDataIsSelf = TRUE;
                
                [self.chatDateLabel_self setText:dateString];
                
                [self.avatarButton_self sd_setBackgroundImageWithURL:[SRImageManager miniAvatarImageFromTXYFieldID:message.avatar_path_from] forState:UIControlStateNormal];
                
                self.imageButton_self.frame = CGRectMake(self.imageButton_self.frame.origin.x, self.imageButton_self.frame.origin.y, body.thumbnailImage.size.width, body.thumbnailImage.size.height);
                
                
                if (body.thumbnailLocalPath) {
                    //如果本地文件存在
                    //图片文件处理
                    [self.imageButton_self setBackgroundImage:[UIImage imageWithContentsOfFile:body.thumbnailLocalPath] forState:UIControlStateNormal];
                } else {
                    //如果本地文件不存在,读取网络文件
                    [self.imageButton_self sd_setBackgroundImageWithURL:[NSURL URLWithString:body.thumbnailRemotePath] forState:UIControlStateNormal];
                }

            } else {
                //他人发的图片
                [self.chatNicknameLabel setText:message.nickname_from];
                [self setTalkingAccountType:4];
                _isImageDataIsSelf = FALSE;
                float conR = [[UIScreen mainScreen] bounds].size.width - body.thumbnailSize.width - 81.0;
                [self.otherViewConRight setConstant:conR];
                
                [self.chatDateLabel setText:dateString];
                
                //处理头像信息
                [self.avatarButton sd_setBackgroundImageWithURL:[SRImageManager miniAvatarImageFromTXYFieldID:message.avatar_path_from] forState:UIControlStateNormal];
                
                
                if (body.thumbnailLocalPath) {
                    //如果本地文件存在
                    //图片文件处理
                    [self.imageButton setBackgroundImage:[UIImage imageWithContentsOfFile:body.thumbnailLocalPath] forState:UIControlStateNormal];
                } else {
                    //如果本地文件不存在,读取网络文件
                    [self.imageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:body.thumbnailRemotePath] forState:UIControlStateNormal];
                }
            }
        }
        default:
            break;
    }
}

- (void)setTalkingAccountType: (int)type {
    switch (type) {
        case 1: {
            //自己发言
            [self.chatMessageTextLabel setHidden:YES];
            [self.chatMessageBackground setHidden:YES];
            [self.chatNicknameLabel setHidden:YES];
            [self.chatDateLabel setHidden:YES];
            
            
            [self.chatMessageTextLabel_self setHidden:NO];
            [self.chatMessageBackground_self setHidden:NO];
            [self.chatDateLabel_self setHidden:NO];
            
            [self.avatarButton setHidden:YES];
            
            [self.imageButton setHidden:YES];
            [self.imageButton_self setHidden:YES];
            
            [self.avatarButton_self setHidden:NO];
            
        }
            break;
        case 2: {
            //其他人发言
            [self.chatMessageTextLabel_self setHidden:YES];
            [self.chatMessageBackground_self setHidden:YES];
            [self.chatDateLabel_self setHidden:YES];
            
            [self.chatMessageTextLabel setHidden:NO];
            [self.chatMessageBackground setHidden:NO];
            [self.chatNicknameLabel setHidden:NO];
            [self.chatDateLabel setHidden:NO];
            
            [self.avatarButton setHidden:NO];
            
            [self.imageButton setHidden:YES];
            [self.imageButton_self setHidden:YES];
            
            [self.avatarButton_self setHidden:YES];
        }
            break;
        case 3: {
            //自己图片信息
            [self.chatMessageTextLabel setHidden:YES];
            [self.chatMessageTextLabel_self setHidden:YES];
            [self.chatMessageBackground setHidden:YES];
            
            [self.chatNicknameLabel setHidden:YES];
            [self.chatDateLabel setHidden:YES];
            
            [self.chatMessageBackground_self setHidden:NO];
            [self.chatDateLabel_self setHidden:NO];
            
            [self.avatarButton setHidden:YES];
            
            [self.imageButton setHidden:YES];
            [self.imageButton_self setHidden:NO];
            
            [self.avatarButton_self setHidden:NO];
            
        }
            break;
        case 4: {
            //他人图片信息
            [self.chatMessageBackground setHidden:NO];
            [self.chatNicknameLabel setHidden:NO];
            [self.chatDateLabel setHidden:NO];
            
            [self.chatMessageTextLabel_self setHidden:YES];
            [self.chatMessageTextLabel setHidden:YES];
            [self.chatMessageBackground_self setHidden:YES];
            [self.chatDateLabel_self setHidden:YES];
            
            [self.avatarButton setHidden:NO];
            
            [self.imageButton setHidden:NO];
            [self.imageButton_self setHidden:YES];
            
            [self.avatarButton_self setHidden:YES];
        }
            break;
        default:
            break;
    }
}



//点击其他人发的图片
- (IBAction)pressedTheImageButton:(UIButton *)sender {
    id<IEMMessageBody> msgBody = _chat.message.messageBodies.firstObject;
    
    [self showImageWithButton:sender andData:msgBody];
    
}

//点击自己发的图片
- (IBAction)pressedTheImageButton_sefl:(UIButton *)sender {
    id<IEMMessageBody> msgBody = _chat.message.messageBodies.firstObject;
    
    [self showImageWithButton:sender andData:msgBody];
    
}

- (void)showImageWithButton: (UIButton *)sender andData: (id<IEMMessageBody>)msgBody {
    EMImageMessageBody *body = ((EMImageMessageBody *)msgBody);
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    
    MJPhoto *photo = [[MJPhoto alloc] init];
    photo.placeholder = [sender backgroundImageForState:UIControlStateNormal];
    photo.srcImageView = sender.imageView; // 来源于哪个UIImageView
    
    UIImage *showImage = [UIImage imageWithContentsOfFile:body.localPath];
    if (showImage) {
        photo.image = showImage;
    } else {
        photo.url = [NSURL URLWithString:body.remotePath]; // 网络路径
    }
    
    [imageArray addObject:photo];
    
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    // 弹出相册时显示的第一张图片是点击的图片
    browser.currentPhotoIndex = 0;
    // 设置所有的图片。photos是一个包含所有图片的数组。
    browser.photos = imageArray;
    [browser show];
}

- (IBAction)pressedTheAvatarButton:(id)sender {
    if (self.topViewController) {
        [self.topViewController.accountView show];
        Model_User *sendUser = [[Model_User alloc] init];
        
        sendUser.pk_user = _chat.fk_user;
        sendUser.nickname = _chat.nickname_from;
        sendUser.avatar_path = _chat.avatar_path_from;
        [self.topViewController.accountView loadWithUser:sendUser withGroup:nil];
    }
    
//    [self.topViewController.accountView show];
//    Model_User *sendUser = [[Model_User alloc] init];
//    sendUser.pk_user = _chat.fk_user;
//    sendUser.nickname = _chat.nickname;
//    sendUser.avatar_path = _chat.avatar_path;
//    [self.topViewController.accountView loadWithUser:sendUser withGroup:self.topViewController.group];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
