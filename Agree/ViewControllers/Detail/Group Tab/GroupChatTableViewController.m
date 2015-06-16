//
//  GroupChatTableViewController.m
//  Agree
//
//  Created by G4ddle on 15/1/19.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "GroupChatTableViewController.h"
#import "Model_Chat.h"
#import "SRNet_Manager.h"

#import "MJExtension.h"
#import <SVProgressHUD.h>
#import "SRImageManager.h"

#import "SRChatLabel.h"

#import "AppDelegate.h"

#import "EaseMob.h"
#import "EModel_Chat.h"

#import "EMCommandMessageBody.h"
#import "EMSendMessageHepler.h"
#import "GroupChatTableViewCell.h"



@interface GroupChatTableViewController () <SRNetManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, SRImageManagerDelegate, UIAlertViewDelegate, EMChatManagerDelegate, SRNetManagerDelegate> {
    SRNet_Manager *_netManager;
    UIImagePickerController *_imagePicker;
    UIImage *_chatPickImage;
    SRImageManager *_imageManager;
    NSString *_imageName;
    Model_Chat *_sendChat;
    
    BOOL _isLocalDone;
    BOOL _dontScroll;
    float _tableViewHeight;
    NSNumber *_chat_last_id;
    NSArray *_relationship;
    
    EMConversation *_conversation;
    

    //初始加载消息页数以及条数
    int page;
    int pageSize;
    
    
     
    
}

@end



@implementation GroupChatTableViewController


- (void)loadChatData {

    
    if (!self.chatArray) {
        self.chatArray = [[NSMutableArray alloc] init];
        page = 1;
        pageSize =15;
        
    }
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    if (!_netManager) {
        _netManager = [[SRNet_Manager alloc] initWithDelegate:self];
    }
    Model_Group *sendGroup = [[Model_Group alloc] init];
    [sendGroup setPk_group:self.group.pk_group];
    [_netManager getAllRelationFromGroup:sendGroup];
    


    
 

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (self.mchatArray) {
        return self.mchatArray.count;
    } else {
        return 0;
    }
}


#pragma mark -- 小组CELL内容

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kCellIdentifier = @"GroupChatCell";
   GroupChatTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    
 
    
    EModel_Chat *message = [self.mchatArray objectAtIndex:indexPath.row];
    if (nil == cell) {
        cell = [[GroupChatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    }
    

    [cell setTopViewController:self.rootController];
    [cell initWithChat:message];
    
      UILongPressGestureRecognizer * longPressGesture =  [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(cellLongPress:)];
    
    id<IEMMessageBody> msgBody = message.message.messageBodies.firstObject;
    
    switch (msgBody.messageBodyType) {
        case eMessageBodyType_Text: {
            //文本
            if (message.sendFromSelf) {
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
            if (message.sendFromSelf) {
                
                
            } else {
                //他人发的图片
                
            }
        }
        default:
            break;
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
#pragma mark -- 消息显示最底层获取消息列表（条件）


    return cell;
    
 
}



#define mark 聊天信息的操作方法
- (void)cellLongPress:(UIGestureRecognizer *)recognizer{
    
    CGPoint location = [recognizer locationInView:self.chatTableView];
    NSIndexPath * indexPath = [self.chatTableView indexPathForRowAtPoint:location];
    //        UserChatTableViewCell *cell = (UserChatTableViewCell *)recognizer.view;
    GroupChatTableViewCell *cell = (GroupChatTableViewCell *)[self.chatTableView cellForRowAtIndexPath:indexPath];
    [cell becomeFirstResponder];
    self.longTapCell = nil;
    self.longTapCell = cell;
    
    [self.rootController longTapCell];
    
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    EModel_Chat *message = [self.mchatArray objectAtIndex:indexPath.row];
    return [self cellHeightFromMessage:message].floatValue;
}


//HeadView高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    float headHight = 0;
    for (EModel_Chat *message in _mchatArray) {
        headHight += [self cellHeightFromMessage:message].floatValue;
    }
    
    headHight = self.chatTableView.frame.size.height - headHight;
    if (headHight <= 0) {
        headHight = 0;
    }
    
    return headHight;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * bgview = [[UIView alloc]init];
    bgview.backgroundColor = [UIColor blackColor];
    self.chatTableView.tableHeaderView = bgview;
    bgview.hidden = YES;
    return bgview;
}


- (void)talkBtnClick:(UITextView *)textViewGet {
    [self sendMessageDone:[EMSendMessageHepler sendTextMessageWithString:textViewGet.text
                                                              toUsername:self.group.em_id
                                                             isChatGroup:YES
                                                       requireEncryption:NO
                                                                     ext:nil]];
}



#pragma mark -- 发送消息结束
- (void)sendMessageDone:(EMMessage *)message {
    Model_Group_User *relation = [[Model_Group_User alloc] init];
    relation.fk_user = [Model_User loadFromUserDefaults].pk_user;
    relation.nickname = [Model_User loadFromUserDefaults].nickname;
    relation.avatar_path = [Model_User loadFromUserDefaults].avatar_path;
    //将信息输入数组,并刷新
    EModel_Chat *chat = [EModel_Chat repackEmessage:message withRelation:relation];
    [self.chatArray addObject:chat];
    
//    [self subChatArray];
//    _mchatArray = (NSMutableArray *)[_chatArray subarrayWithRange:NSMakeRange(0,_pageSize*_page)];

    [self reloadTableViewIsScrollToBottom:YES withAnimated:YES];
    
    if (!_netManager) {
        _netManager = [[SRNet_Manager alloc] initWithDelegate:self];
    }
    Model_Chat *newChat = [[Model_Chat alloc] init];
    [newChat setFk_user:[Model_User loadFromUserDefaults].pk_user];
    [newChat setFk_group:self.group.pk_group];
    [newChat setNickname:[Model_User loadFromUserDefaults].nickname];
    
    id<IEMMessageBody> msgBody = message.messageBodies.firstObject;
    switch (msgBody.messageBodyType) {
        case eMessageBodyType_Text: {
            newChat.content = ((EMTextMessageBody *)msgBody).text;
        }
            break;
        case eMessageBodyType_Image: {
            newChat.content = @"[图片]";
        }
            break;
        default:
            break;
    }

    [_netManager addChatMessageToGroup:newChat];
}

- (void)imageBtnClick {
    //点击图片按钮
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        //判断是否有摄像头
        if(![UIImagePickerController isSourceTypeAvailable:sourceType]) {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择图片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"图片库", nil];
        [sheet showInView:self.rootController.view];
    }
}



- (void)reloadTableViewIsScrollToBottom: (BOOL) isScroll
                           withAnimated: (BOOL)isAnimated {
    
    float headHight = 0;
    for (EModel_Chat *message in _mchatArray) {
        headHight += [self cellHeightFromMessage:message].floatValue;
    }
    
    
    headHight = self.chatTableView.frame.size.height - headHight;
    if (headHight <= 0) {
        headHight = 0;
    }
    
    self.chatTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.chatTableView.frame.size.width, headHight)];

    
    [self.chatTableView reloadData];
    if (isScroll) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSInteger s = [self.chatTableView numberOfSections];
            if (s<1) return;
            NSInteger r = [self.chatTableView numberOfRowsInSection:s-1];
            if (r<1) return;
            NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];
            
            [self.chatTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:isAnimated];
        });
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
    [self.rootController presentViewController:_imagePicker animated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];

    _chatPickImage = [info valueForKey:@"UIImagePickerControllerOriginalImage"];
    
    //初始化图片发送确认警告框
    UIAlertView *sendImageAlert = [[UIAlertView alloc] initWithTitle:@"确认信息"
                                                             message:@"是否确认发送图片?"
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                                   otherButtonTitles:@"确认", nil];
    [sendImageAlert show];
}

- (void)sendImage {
    [self sendMessageDone:[EMSendMessageHepler sendImageMessageWithImage:_chatPickImage
                                                              toUsername:self.group.em_id
                                                             isChatGroup:YES
                                                       requireEncryption:NO
                                                                     ext:nil]];
}

- (void)didReceiveMessage:(EMMessage *)message {
    EMError *error = nil;
    message = [[EaseMob sharedInstance].chatManager fetchMessageThumbnail:message progress:nil error:&error];
    //这里将自动下载附件
    if (!error) {
        //完成
    }
    EModel_Chat *chat;
    for (Model_Group_User *group_user in _relationship) {
        if ([group_user.fk_user.stringValue isEqualToString:message.groupSenderName]) {
            chat = [EModel_Chat repackEmessage:message withRelation:group_user];
        }
    }
    if (chat) {
        [self.chatArray addObject:chat];
    }
    
    [_conversation markAllMessagesAsRead:YES];
    [self reloadTableViewIsScrollToBottom:YES withAnimated:YES];
    

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (0 == buttonIndex) {
        //取消发送
    } else {
        //确认发送
        [self sendImage];
    }
    
}

- (NSNumber *)cellHeightFromMessage:(EModel_Chat *)message {
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
            EMImageMessageBody *body = ((EMImageMessageBody *)msgBody);
            //图片
            if (message.sendFromSelf) {
                //自己发的图片
                //设置行高为图片标准高度
                 return [NSNumber numberWithFloat:body.thumbnailSize.height + 40.0];
            } else {
                //他人发的图片
                return [NSNumber numberWithFloat:body.thumbnailSize.height + 45.0];
            }
        }
            break;
        default:
            return 0;
            break;
    }
    
}
- (void)interfaceReturnDataSuccess:(id)jsonDic with:(int)interfaceType {
    switch (interfaceType) {
        case kGetAllRelationFromGroup: {
            if (jsonDic) {
                //读取信息
                
                [SVProgressHUD dismiss];
                
                if (!_relationship) {
                    _relationship = [[NSMutableArray alloc] init];
                }
                if (jsonDic) {
                    _relationship = [Model_Group_User objectArrayWithKeyValuesArray:jsonDic];
                    
                    //读取私信的消息列表
                    _conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:self.group.em_id isGroup:YES];
                    NSArray *messages = [_conversation loadAllMessages];
                    
                    for (EMMessage *message in messages) {
                        EModel_Chat *chat;
                        
                        for (Model_Group_User *group_user in _relationship) {
                            //如果关系为2,则为群主
                            if ([group_user.role isEqualToNumber:@1]) {
                                self.rootController.group.creater = group_user.fk_user;
                            }
                            
                            if ([group_user.fk_user.stringValue isEqualToString:message.groupSenderName]) {
                                chat = [EModel_Chat repackEmessage:message withRelation:group_user];
                            }
                        }
                        if (chat) {
                            [self.chatArray addObject:chat];
                            //加载消息的数组个数
//                            [self subChatArray];
                        }
                        
                        //加载消息的数组个数
//                        [self subChatArray]
                        
                    }
                    //加载消息的数组个数
                    [self subChatArray];
//                    _mchatArray = _chatArray;

                    
                    
                    [_conversation markAllMessagesAsRead:YES];
                    //清空小组的提示
                    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    [delegate.groupDelegate setDataChange:TRUE];
                    
                    //聊天信息切换到最底层显示
                    if (messages.count == 0) {
                        return;
                    }
                        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:_mchatArray.count-1  inSection:0];
                        
                        [self reloadTableViewIsScrollToBottom:NO withAnimated:NO];
                        
                    if (!(0 >= indexPath.row)) {
                        [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                    }
                } 
            }
        }
            break;
        case kAddChatMessageToGroup: {
            [SVProgressHUD dismiss];
        }
            break;
        default:
            break;
    }
    
    [SVProgressHUD dismiss];
}

- (void)subChatArray {
    

    
    
    _mchatArray = (NSMutableArray *)[_chatArray subarrayWithRange:NSMakeRange(_chatArray.count - (pageSize*page),pageSize*page)];
}

- (void)tableViewIsScrollToBottom: (BOOL) isScroll
                     withAnimated: (BOOL)isAnimated {
    
    float headHight = 0;
    for (EModel_Chat *message in _mchatArray) {
        headHight += [self cellHeightFromMessage:message].floatValue;
    }
    
    headHight = self.chatTableView.frame.size.height - headHight;
    if (headHight <= 0) {
        headHight = 0;
    }
    
    self.chatTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.chatTableView.frame.size.width, headHight)];
    if (isScroll) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSInteger s = [self.chatTableView numberOfSections];
            if (s<1) return;
            NSInteger r = [self.chatTableView numberOfRowsInSection:s-1];
            if (r<1) return;
            NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];
            
            [self.chatTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:isAnimated];
        });
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
#pragma mark -- 下拉加载数据

    float contentoffsetY = _chatTableView.contentOffset.y;

    //判断如果下拉超过限定 就加载数据
    if ((-120  >= (contentoffsetY))&&!(_mchatArray.count == _chatArray.count) ){
        NSLog(@"下拉如果超过-110realoadata");
        page++;
        NSLog(@"%d",page);
        [self subChatArray];
        [_chatTableView reloadData];
        


    }
    //默认一次10个 这是最后一次加载大于0小于10的个数
    else if( self.chatArray.count - self.mchatArray.count > 0 && self.chatArray.count - self.mchatArray.count < 15  ){
        self.mchatArray = self.chatArray;

        [_chatTableView reloadData];

    }else if( self.mchatArray.count == self.chatArray.count )
    {
        NSLog(@"数组已经加载结束 停止加载");
    }

    NSLog(@"%d",self.mchatArray.count);
    NSLog(@"%d",self.chatArray.count);
    NSLog(@"%F",contentoffsetY);


}



- (void)interfaceReturnDataError:(int)interfaceType {
    [SVProgressHUD dismiss];
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
