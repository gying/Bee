//
//  UserChatViewController.m
//  Agree
//
//  Created by G4ddle on 15/3/24.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "UserChatViewController.h"
#import "Model_User_Chat.h"
#import "SRImageManager.h"
#import "SRNet_Manager.h"
#import "MJExtension.h"
#import <SVProgressHUD.h>
#import "UserChatTableViewCell.h"
#import "AppDelegate.h"
#import "EaseMob.h"
#import "EModel_User_Chat.h"
#import "EMSendMessageHepler.h"
#import "SRKeyboard.h"



#define kLoadChatData       1
#define kSendMessage        2

@interface UserChatViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UIAlertViewDelegate, EMChatManagerDelegate,UITableViewDelegate> {
    SRNet_Manager *_netManager;
    int _netStatus;
    
    SRKeyboard *_srKeyBoard;
    UIImagePickerController *_imagePicker;
    
    UIImage *_chatPickImage;
    SRImageManager *_imageManager;
    NSString *_imageName;
    
    Model_User_Chat *_userChat;
    NSMutableArray *_chatArray;
    
    UIAlertView *_sendImageAlert;
    EMConversation *_conversation;
}

@end


@implementation UserChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.accountView = [[SRAccountView alloc] init];
    self.accountView.rootController = self;
    
    //
    self.automaticallyAdjustsScrollViewInsets = false;
    
    
    //读取私信的消息列表
    _conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:self.user.pk_user.stringValue isGroup:NO];
    
    NSArray *messages = [_conversation loadAllMessages];
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    //可变数组
    _chatArray = [[NSMutableArray alloc] init];
    for (EMMessage *message in messages) {
        EModel_User_Chat *chat;
        if ([self.user.pk_user.stringValue isEqualToString:message.from]) {
            //对方发的信息
            chat = [EModel_User_Chat repackEmessage:message withSender:self.user];
        } else {
            //自己发的信息
            Model_User *user = [[Model_User alloc] init];
            user.pk_user = [Model_User loadFromUserDefaults].pk_user;
            user.nickname = [Model_User loadFromUserDefaults].nickname;
            user.avatar_path = [Model_User loadFromUserDefaults].avatar_path;
            chat = [EModel_User_Chat repackEmessage:message withSender:user];
        }
        [_chatArray addObject:chat];
    }
    
    
    [self.navigationItem setTitle:self.user.nickname];
    
    //初始化图片发送确认警告框
    _sendImageAlert = [[UIAlertView alloc] initWithTitle:@"确认信息"
                                                 message:@"是否确认发送图片?"
                                                delegate:self
                                       cancelButtonTitle:@"取消"
                                       otherButtonTitles:@"确认", nil];
    [self.userChatTableView reloadData];
    [self tableViewIsScrollToBottom:YES withAnimated:NO];
    [_conversation markAllMessagesAsRead:YES];
    
    //    [self.rootController.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    _srKeyBoard = [[SRKeyboard alloc] init];
    [_srKeyBoard textViewShowView:self
           customKeyboardDelegate:self
                     withMoveView:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    _srKeyBoard = nil;
}


- (void)didReceiveMessage:(EMMessage *)message {
    [_conversation markAllMessagesAsRead:YES];
    if ([message.from isEqualToString:self.user.pk_user.stringValue]) {
        EMError *error = nil;
        message = [[EaseMob sharedInstance].chatManager fetchMessageThumbnail:message progress:nil error:&error];
        //这里将自动下载附件
        if (!error) {
            //完成
        }
        EModel_User_Chat *chat = [EModel_User_Chat repackEmessage:message withSender:self.user];
        [_chatArray addObject:chat];
        [self.userChatTableView reloadData];
        [self tableViewIsScrollToBottom:YES withAnimated:YES];
    }
}

- (IBAction)tapBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


//HeadView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * HeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 0)];
    
    
    //  HeadView.backgroundColor = [UIColor blackColor];
    
    _userChatTableView.tableHeaderView = HeadView;
    
    //    _userChatTableView.tableHeaderView.backgroundColor = [UIColor blackColor];
    
    return HeadView;
}

//HeadView高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 210;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (_chatArray) {
        return _chatArray.count;
    } else {
        return 0;
    }
}

//Cell内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kCellIdentifier = @"UserChatCell";
    UserChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    //
    
    EModel_User_Chat *chat = [_chatArray objectAtIndex:indexPath.row];
    if (nil == cell) {
        cell = [[UserChatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    }
    

    UILongPressGestureRecognizer * longPressGesture =  [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(cellLongPress:)];
    
    [cell setTopViewController:self];
    [cell initWithChat:chat];
    
    id<IEMMessageBody> msgBody = chat.message.messageBodies.firstObject;
    
    switch (msgBody.messageBodyType) {
        case eMessageBodyType_Text: {
            //文本
            if (chat.sendFromSelf) {
                //自己发言
                [cell.messageBackgroundButton_self addGestureRecognizer:longPressGesture];
                
            } else {
                //他人发的信息
                [cell.messageBackgroundButton addGestureRecognizer:longPressGesture];
            }
        }
            break;
        case eMessageBodyType_Image: {
            //图片
            if (chat.sendFromSelf) {
                
                
            } else {
            //他人发的图片

            }
        }
        default:
            break;
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}


//CELL自适应消息高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //message内容
    EModel_User_Chat *message = [_chatArray objectAtIndex:indexPath.row];
    
    return [self cellHeightFromMessage:message].floatValue;
}


//
- (NSNumber *)cellHeightFromMessage:(EModel_User_Chat *)message {
    id<IEMMessageBody> msgBody = message.message.messageBodies.firstObject;
    
    switch (msgBody.messageBodyType) {
        case eMessageBodyType_Text: {
            //文本
            if (!((EMTextMessageBody *)msgBody).text.length) {
                ((EMTextMessageBody *)msgBody).text = @"  ";
            }
            if (message.sendFromSelf) {
                //自己发的信息
                //自己发言
                UILabel *chatLabel_self = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width - 185, MAXFLOAT)];
                
                
                [chatLabel_self setFont:[UIFont systemFontOfSize:14]];
                [chatLabel_self setLineBreakMode:NSLineBreakByWordWrapping];
                [chatLabel_self setTextAlignment:NSTextAlignmentLeft];
                [chatLabel_self setNumberOfLines:0];
                
                chatLabel_self.text = ((EMTextMessageBody *)msgBody).text;
                //在这里进行宽度的测算
                NSDictionary *attribute = @{NSFontAttributeName: chatLabel_self.font};
                CGSize wSize = [((EMTextMessageBody *)msgBody).text boundingRectWithSize:chatLabel_self.frame.size options:NSStringDrawingTruncatesLastVisibleLine  attributes:attribute context:nil].size;
                
                if (!message.cell_width) {
                    [message setCell_width:[NSNumber numberWithFloat:wSize.width + 2.0]];
                }
                
                CGSize size = [chatLabel_self sizeThatFits:chatLabel_self.frame.size];
                
                return [NSNumber numberWithFloat:size.height + 45.0];
            } else {
                //他人发的信息
                UILabel *chatLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width - 132, MAXFLOAT)];
                
                
                
                [chatLabel setFont:[UIFont systemFontOfSize:14]];
                [chatLabel setLineBreakMode:NSLineBreakByWordWrapping];
                [chatLabel setTextAlignment:NSTextAlignmentLeft];
                [chatLabel setNumberOfLines:0];
                chatLabel.text = ((EMTextMessageBody *)msgBody).text;
                //在这里进行宽度的测算
                NSDictionary *attribute = @{NSFontAttributeName: chatLabel.font};
                CGSize wSize = [((EMTextMessageBody *)msgBody).text boundingRectWithSize:chatLabel.frame.size options:NSStringDrawingTruncatesLastVisibleLine  attributes:attribute context:nil].size;
                
                if (!message.cell_width) {
                    [message setCell_width:[NSNumber numberWithFloat:wSize.width + 2.0]];
                }
                
                //在这里进行高度的测算
                CGSize size = [chatLabel sizeThatFits:CGSizeMake([[UIScreen mainScreen] bounds].size.width - 132, MAXFLOAT)];
                return [NSNumber numberWithFloat:size.height + 50.0];
            }
        }
            break;
        case eMessageBodyType_Image: {
            //图片
            EMImageMessageBody *body = ((EMImageMessageBody *)msgBody);
            if (message.sendFromSelf) {
                //自己发的图片
                
                //设置行高为图片标准高度
                return [NSNumber numberWithFloat:body.thumbnailSize.height/2 + 40.0];
            } else {
                //他人发的图片
                return [NSNumber numberWithFloat:body.thumbnailSize.height + 45.0];
            }
        }
        default:
            return 0;
            break;
    }
}



#pragma mark - key board
- (void)talkBtnClick:(UITextView *)textViewGet {
    [self sendMessageDone:[EMSendMessageHepler sendTextMessageWithString:textViewGet.text
                                                              toUsername:self.user.pk_user.stringValue
                                                             isChatGroup:NO
                                                       requireEncryption:NO
                                                                     ext:nil]];
}


//输入框左边BUTTON（图片发送选择)
- (void)imageBtnClick {
    //点击图片按钮
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        [_imagePicker setDelegate:self];
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        //判断是否有摄像头
        if(![UIImagePickerController isSourceTypeAvailable:sourceType]) {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"图片库", nil];
        [sheet showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    UIImagePickerControllerSourceType sourceType;
    
    if (0 == buttonIndex) {
        //直接拍照
        sourceType = UIImagePickerControllerSourceTypeCamera;
    } else if (1 == buttonIndex) {
        //使用相册
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    } else {
        return;
    }
    _imagePicker.sourceType = sourceType;
    [self presentViewController:_imagePicker animated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    _chatPickImage = [info valueForKey:@"UIImagePickerControllerOriginalImage"];
    [_sendImageAlert show];
}

- (void)sendImage {
    [self sendMessageDone:[EMSendMessageHepler sendImageMessageWithImage:_chatPickImage
                                                              toUsername:self.user.pk_user.stringValue
                                                             isChatGroup:NO
                                                       requireEncryption:NO
                                                                     ext:nil]];
}

- (void)sendMessageDone:(EMMessage *)message {
    //自己发的信息
    Model_User *user = [[Model_User alloc] init];
    user.pk_user = [Model_User loadFromUserDefaults].pk_user;
    user.nickname = [Model_User loadFromUserDefaults].nickname;
    user.avatar_path = [Model_User loadFromUserDefaults].avatar_path;
    
    //将信息输入数组,并刷新
    EModel_User_Chat *chat = [EModel_User_Chat repackEmessage:message withSender:user];
    [_chatArray addObject:chat];
    [self.userChatTableView reloadData];
    [self tableViewIsScrollToBottom:YES withAnimated:YES];
}

- (void)tableViewIsScrollToBottom: (BOOL) isScroll
                     withAnimated: (BOOL)isAnimated {
    if (isScroll) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSInteger s = [self.userChatTableView numberOfSections];
            if (s<1) return;
            NSInteger r = [self.userChatTableView numberOfRowsInSection:s-1];
            if (r<1) return;
            NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];
            
            [self.userChatTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:isAnimated];
        });
    }
}


//详情BUTTON
- (IBAction)tapDetailButton:(id)sender {
    [self.accountView loadWithUser:self.user withGroup:nil];
    [self.accountView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (0 == buttonIndex) {
        //取消发送
    } else {
        //确认发送
        [self sendImage];
    }
}

#define mark 聊天信息的操作方法
- (void)cellLongPress:(UIGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        CGPoint location = [recognizer locationInView:self.userChatTableView];
        NSIndexPath * indexPath = [self.userChatTableView indexPathForRowAtPoint:location];
        //        UserChatTableViewCell *cell = (UserChatTableViewCell *)recognizer.view;
        UserChatTableViewCell *cell = (UserChatTableViewCell *)[self.userChatTableView cellForRowAtIndexPath:indexPath];
        [cell becomeFirstResponder];
        
        UIMenuItem *itCopy = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(handleCopyCell:)];
        UIMenuItem *itReSend = [[UIMenuItem alloc] initWithTitle:@"再次发送" action:@selector(handleResendCell:)];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setMenuItems:[NSArray arrayWithObjects:itCopy,itReSend, nil]];
        
        
        
        EModel_User_Chat *chat = [_chatArray objectAtIndex:indexPath.row];
        
        
        id<IEMMessageBody> msgBody = chat.message.messageBodies.firstObject;
        
        switch (msgBody.messageBodyType) {
            case eMessageBodyType_Text: {
                //文本
                if (chat.sendFromSelf) {
                    //自己发言
                    [menu setTargetRect:CGRectMake(cell.chatMessageBackground_self.frame.origin.x, cell.frame.origin.y + 30, cell.messageBackgroundButton_self.frame.size.width, cell.messageBackgroundButton_self.frame.size.height) inView:self.userChatTableView];
                    
                } else {
                    //他人发的信息
                    [menu setTargetRect:CGRectMake(cell.chatMessageBackground.frame.origin.x, cell.frame.origin.y + 30, cell.messageBackgroundButton.frame.size.width, cell.messageBackgroundButton.frame.size.height) inView:self.userChatTableView];
                }
            }
                break;
            case eMessageBodyType_Image: {
                //图片
                if (chat.sendFromSelf) {
                    
                    
                } else {
                    //他人发的图片
                    
                }
            }
            default:
                break;
        }
        
        [menu setMenuVisible:YES animated:YES];
    }
}

- (void)handleCopyCell:(id)sender {
    NSLog(@"handle copy cell");
}

- (void)handleResendCell:(id)sender {
    NSLog(@"handle resend cell");
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */





@end
