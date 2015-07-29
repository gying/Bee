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
#define kBaseUrlString  @"http://120.26.118.226/app/app_interface/"
#define kInterfaceUrlString @"sr_interface.php"

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
#define kUpdatePartyRelationships   451

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
#define kShareParty                 411


#define kGetCreatedParty            412
#define kGetPartyHistory            413


#define kImageManagerSign           101

#define kTestInterface              1101
#define kGetUserInfoByWechat        1102

//定义两个代码块
typedef void (^finishCallbackBlock)(NSString *msgString, id jsonDic, int interType, NSURLSessionDataTask *task);
typedef void (^requestFailureBlock)(NSError *error, NSURLSessionDataTask *task);

@interface SRNet_Manager : NSObject


@property (strong)finishCallbackBlock completeBlock;
@property (strong)requestFailureBlock failureBlock;


+ (void)requestNetWithDic:(NSMutableDictionary *)sendDic
                 complete:(finishCallbackBlock)completeBlock
                  failure:(requestFailureBlock)failureBlock;


+ (NSMutableDictionary *)addGroupDic: (Model_Group *)newGroup withMembers: (NSMutableArray *)members;
+ (NSMutableDictionary *)regUserDic: (Model_User *)newUser;
+ (NSMutableDictionary *)getUserGroupsDic: (Model_User *)user;

+ (NSMutableDictionary *)addChatMessageToGroupDic: (Model_Chat *)chat;
+ (NSMutableDictionary *)addScheduleDic: (Model_Party *)party;
+ (NSMutableDictionary *)getAllScheduleByUserDic: (Model_User *)user;
+ (NSMutableDictionary *)generationCodeByGroupDic: (Model_Group *)group;
+ (NSMutableDictionary *)joinTheGroupByCodeDic: (Model_Group_Code *)code;
+ (NSMutableDictionary *)getScheduleByGroupIDDic: (NSNumber *)group_id
                                      withUserID: (NSNumber *)user_id
                                       withRelID: (NSNumber *)pk_group_user;
+ (NSMutableDictionary *)updateScheduleDic: (Model_Party_User *)relation;

+ (NSMutableDictionary *)getPartyRelationshipDic: (Model_Party *)party;
+ (NSMutableDictionary *)addImageToGroupDic: (Model_Photo *)photo;
+ (NSMutableDictionary *)getPhotoByGroupDic: (Model_Group *)group;
+ (NSMutableDictionary *)joinGroupDic: (Model_Group_User *)rel;
+ (NSMutableDictionary *)updateGroupRelationShip: (Model_Group_User *)rel;
+ (NSMutableDictionary *)getGroupRelationshipDic: (Model_Group_User *)rel;
+ (NSMutableDictionary *)getUserInfoDic: (Model_User *)user;
+ (NSMutableDictionary *)updateUserInfoDic: (Model_User *)user;
+ (NSMutableDictionary *)getAllRelationFromGroupDic: (Model_Group *)group;
+ (NSMutableDictionary *)sendVerificationCodeDic: (NSString *)phoneNum;
+ (NSMutableDictionary *)getUserByPhoneDic: (Model_User *)user;
+ (NSMutableDictionary *)addFriendDic: (Model_user_user *)userRelation;
+ (NSMutableDictionary *)getFriendListDic: (Model_User *)user;
+ (NSMutableDictionary *)matchPhonesDic: (NSMutableArray *)phones;
+ (NSMutableDictionary *)becomeFriendDic: (Model_user_user *)userRelation;
+ (NSMutableDictionary *)checkRelationDic: (Model_user_user *)userRelation;
+ (NSMutableDictionary *)addUserChatDic: (Model_User_Chat *)userChat;
+ (NSMutableDictionary *)getUserChat: (Model_user_user *)userRelation;
+ (NSMutableDictionary *)checkAccountDic: (Model_User *)user;
+ (NSMutableDictionary *)loginAccountDic: (Model_User *)user;
+ (NSMutableDictionary *)feedBackMessageDic: (Model_Feedback *)feedback;
+ (NSMutableDictionary *)removeFriendDic: (Model_user_user *)relation;
+ (NSMutableDictionary *)removePhotoDic: (Model_Photo *)photo;
+ (NSMutableDictionary *)createRelationshipForPartyDic: (Model_Party_User *)relation;
+ (NSMutableDictionary *)cancelPartyDic: (Model_Party *)party;
+ (NSMutableDictionary *)sharePartyDic: (Model_Party *)party;
+ (NSMutableDictionary *)imageManagerSignDic;
+ (NSMutableDictionary *)testInterfaceDic;
+ (NSMutableDictionary *)getUserInfoByWechatDic: (Model_User *)user;
+ (NSMutableDictionary *)getCreatedPartyByUserDic: (Model_User *)user;
+ (NSMutableDictionary *)getPartyHistoryByUserDic: (Model_User *)user;
+ (NSMutableDictionary *)updatePartyRelationships: (NSMutableArray *)partyRelationAry;

@end
