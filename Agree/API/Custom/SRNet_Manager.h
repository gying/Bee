//
//  SRNet_Manager.h
//  SRAgree
//
//  Created by G4ddle on 14/12/24.
//  Copyright (c) 2014年 G4ddle. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Model_Group.h"
#import "Model_User.h"
#import "Model_Group_User.h"
#import "Model_Chat.h"

#import "Model_Party.h"
#import "Model_Party_User.h"
#import "Model_Group_Code.h"
#import "Model_Photo.h"
#import "Model_user_user.h"
#import "Model_User_Chat.h"
#import "Model_Feedback.h"

//定义请求地址
//#define kBaseUrlString  @"http://203.195.159.110/webroot/"

//#define kBaseUrlString  @"http://interface.beagree.com/webroot/"

//#define kBaseUrlString @"http://interfacecdn.beagree.com/SR/interface/webroot/"

#define kBaseUrlString @"http://srinterfacecdn.beagree.com/webroot/"
#define kInterfaceUrlString @"sr_interface.php"
//#define kInterfaceUrlString @"srtext.php"


#define kAddGroup                   31
#define kRegUser                    11
#define kGetUserGroups              32
#define kGetChatMessageByGroup      51
#define kAddChatMessageToGroup      52
#define kAddSchedule                47
#define kGetAllScheduleByUser       41
#define kGenerationCodeByGroup      37
#define kJoinTheGroupByCode         38
#define kGetScheduleByGroupID       43
#define kUpdateSchedule             45
#define kGetPartyRelationship       48
#define kAddImageToGroup            62
#define kGetPhotoByGroup            61
#define kJoinGroup                  39
#define kUpdateGroupRelationShip    34
#define kGetGroupRelationship       33
#define kGetUserInfo                17
#define kUpdateUserInfo             15
#define kGetAllRelationFromGroup    36
#define kSendVerificationCode       18
#define kGetUserByPhone             19
#define kAddFriend                  71
#define kGetFriendList              72
#define kMatchPhones                73
#define kBecomeFriend               74
#define kCheckRelation              75
#define kAddUserChat                81
#define kGetUserChat                82
#define kCheckAccount               111
#define kLoginAccount               12
#define kFeedBackMessage            91
#define kRemoveFriend               76
#define kRemovePhoto                63
#define kCreateRelationForParty     49
#define kCancelParty                46


#define kImageManagerSign           101

#define kTestInterface              1101




//建立代理协议
@protocol SRNetManagerDelegate <NSObject>
@required
- (void)interfaceReturnDataSuccess: (id)jsonDic with:(int)interfaceType;
- (void)interfaceReturnDataError:(int)interfaceType;

@end

@interface SRNet_Manager : NSObject
@property (nonatomic, weak)id<SRNetManagerDelegate> delegate;
//以建立代理协议的模式初始化
- (id)initWithDelegate: (id<SRNetManagerDelegate>)delegate;

- (BOOL)addGroup: (Model_Group *)newGroup withMembers: (NSMutableArray *)members;
- (BOOL)regUser: (Model_User *)newUser;
- (BOOL)getUserGroups: (Model_User *)user;
- (BOOL)getChatMessageByGroup: (Model_Group *)group;
- (BOOL)addChatMessageToGroup: (Model_Chat *)chat;
- (BOOL)addSchedule: (Model_Party *)party;
- (BOOL)getAllScheduleByUser: (Model_User *)user;
- (BOOL)generationCodeByGroup: (Model_Group *)group;
- (BOOL)joinTheGroupByCode: (Model_Group_Code *)code;
- (BOOL)getScheduleByGroupID: (NSNumber *)group_id withUserID: (NSNumber *)user_id withRelID: (NSNumber *)pk_group_user;
- (BOOL)updateSchedule: (Model_Party_User *)relation;
- (BOOL)getPartyRelationship: (Model_Party *)party;
- (BOOL)addImageToGroup: (Model_Photo *)photo;
- (BOOL)getPhotoByGroup: (Model_Group *)group;
- (BOOL)joinGroup: (Model_Group_User *)rel;
- (BOOL)updateGroupRelationShip: (Model_Group_User *)rel;
- (BOOL)getGroupRelationship: (Model_Group_User *)rel;
- (BOOL)getUserInfo: (Model_User *)user;
- (BOOL)updateUserInfo: (Model_User *)user;
- (BOOL)getAllRelationFromGroup: (Model_Group *)group;
- (BOOL)sendVerificationCode: (NSString *)phoneNum;
- (BOOL)getUserByPhone: (Model_User *)user;
- (BOOL)addFriend: (Model_user_user *)userRelation;
- (BOOL)getFriendList: (Model_User *)user;
- (BOOL)matchPhones: (NSMutableArray *)phones;
- (BOOL)becomeFriend: (Model_user_user *)userRelation;
- (BOOL)checkRelation: (Model_user_user *)userRelation;
- (BOOL)addUserChat: (Model_User_Chat *)userChat;
- (BOOL)getUserChat: (Model_user_user *)userRelation;
- (BOOL)checkAccount: (Model_User *)user;
- (BOOL)loginAccount: (Model_User *)user;
- (BOOL)feedBackMessage: (Model_Feedback *)feedback;
- (BOOL)removeFriend: (Model_user_user *)relation;
- (BOOL)removePhoto: (Model_Photo *)photo;
- (BOOL)createRelationshipForParty: (Model_Party_User *)relation;
- (BOOL)cancelParty: (Model_Party *)party;
- (BOOL)imageManagerSign;
- (BOOL)testInterface;
@end
