//
//  SRNet_Manager.m
//  SRAgree
//
//  Created by G4ddle on 14/12/24.
//  Copyright (c) 2014年 G4ddle. All rights reserved.
//

#import "SRNet_Manager.h"
#import <SVProgressHUD.h>
#import "AFNetworking.h"
#import "MJExtension.h"

@implementation SRNet_Manager

@synthesize completeBlock;
@synthesize failureBlock;

+ (void)requestNetWithDic:(NSMutableDictionary *)sendDic
                 complete:(finishCallbackBlock)completeBlock
                  failure:(requestFailureBlock)failureBlock {
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", kBaseUrlString, kInterfaceUrlString];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    
    
    SRNet_Manager *netManager = [[SRNet_Manager alloc] init];
    netManager.completeBlock = completeBlock;
    netManager.failureBlock = failureBlock;
    
    
    [manager POST:urlString
       parameters:sendDic
          success:^(NSURLSessionDataTask *task, id responseObject) {
              //返回成功
              if (netManager.completeBlock) {
                  
                  NSMutableDictionary *dic = responseObject;
                  int interfaceType = [[dic  objectForKey:@"interface"] intValue];
                  id returnData = [dic objectForKey:@"returnData"];
                  
                  if (![dic  objectForKey:@"statusMsg"]) {
                      //如果返回信息码不存在
                      netManager.completeBlock(@"返回信息码不存在", nil, interfaceType, task);
                  } else {
                      //返回信息码存在
                      NSNumber *statusNum = [dic  objectForKey:@"statusMsg"];
                      if (0 == statusNum.intValue) {
                          netManager.completeBlock(@"返回信息码为0", nil, interfaceType, task);
                      } else {
                          if (returnData) {
                              //返回数据存在
                              netManager.completeBlock(@"接口返回成功", returnData, interfaceType, task);
                          }else {
                              //返回数据不存在
                              netManager.completeBlock(@"接口返回成功,但是数据为空", nil, interfaceType, task);
                          }
                      }
                  }
              }
              
              
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                //请求失败
                if (netManager.failureBlock) {
                    [SVProgressHUD showErrorWithStatus:@"网络错误"];
                    netManager.failureBlock(error, task);
                }
            }
     ];
}

// 将字典或者数组转化为JSON串
+ (NSData *)toJSONData:(id)theData{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:0
                                                         error:&error];
    if ([jsonData length] > 0 && error == nil){
        return jsonData;
    }else{
        return nil;
    }
}

+ (NSMutableDictionary *)toRequestDicWithData: (id)requestData andRequestType:(int)requestType {
    NSMutableDictionary *requestDic = [[NSMutableDictionary alloc] init];
    
    [requestDic setObject:[NSNumber numberWithInt:requestType] forKey:@"request_type"];
    if ([requestData isKindOfClass:[NSDictionary class]]) {
        //如果数据为数组
        [requestDic setObject:[[NSString alloc] initWithData:[SRNet_Manager toJSONData:requestData] encoding:NSUTF8StringEncoding] forKey:@"request_data"];
    } else {
        //如果数据为字符串 (暂定二重判断)
        [requestDic setObject:[[NSString alloc] initWithData:[SRNet_Manager toJSONData:requestData] encoding:NSUTF8StringEncoding] forKey:@"request_data"];
    }
    
    return requestDic;
}
//增加小组
+ (NSMutableDictionary *)addGroupDic: (Model_Group *)newGroup withMembers: (NSMutableArray *)members {
    
    NSMutableDictionary *newGroupDic = [[NSMutableDictionary alloc] init];
    [newGroupDic setValue:newGroup.keyValues forKey:@"group"];
    
    NSMutableArray *newUserAry = [[NSMutableArray alloc] init];
    for (Model_Group_User *group_user in members) {
        [newUserAry addObject:group_user.keyValues];
    }
    [newGroupDic setValue:newUserAry forKey:@"member"];
    
    return [SRNet_Manager toRequestDicWithData:newGroupDic andRequestType:kAddGroup];
}

//注册用户
+ (NSMutableDictionary *)regUserDic: (Model_User *)newUser {
    return [SRNet_Manager toRequestDicWithData:newUser.keyValues
                                andRequestType:kRegUser];
}

//获取用户的小组信息
+ (NSMutableDictionary *)getUserGroupsDic: (Model_User *)user {
    return [SRNet_Manager toRequestDicWithData:user.keyValues
                                andRequestType:kGetUserGroups];
}

//增加一条聊天信息
+ (NSMutableDictionary *)addChatMessageToGroupDic: (Model_Chat *)chat {
    return [SRNet_Manager toRequestDicWithData:chat.keyValues
                                andRequestType:kAddChatMessageToGroup];
}

//添加一条行程
+ (NSMutableDictionary *)addScheduleDic: (Model_Party *)party {
    return [SRNet_Manager toRequestDicWithData:party.keyValues
                                andRequestType:kAddSchedule];
}

//读取用户下所有的聚会信息
+ (NSMutableDictionary *)getAllScheduleByUserDic: (Model_User *)user {
    return [SRNet_Manager toRequestDicWithData:user.keyValues
                                andRequestType:kGetAllScheduleByUser];
}

//返回小组邀请码
+ (NSMutableDictionary *)generationCodeByGroupDic: (Model_Group *)group {
    return [SRNet_Manager toRequestDicWithData:group.keyValues
                                andRequestType:kGenerationCodeByGroup];
}

//使用邀请码加入小组
+ (NSMutableDictionary *)joinTheGroupByCodeDic: (Model_Group_Code *)code {
    return [SRNet_Manager toRequestDicWithData:code.keyValues
                                andRequestType:kJoinTheGroupByCode];
}

//读取小组聚会列表
+ (NSMutableDictionary *)getScheduleByGroupIDDic: (NSNumber *)group_id
                  withUserID: (NSNumber *)user_id
                   withRelID: (NSNumber *)pk_group_user {
    return [SRNet_Manager toRequestDicWithData:[[NSDictionary alloc] initWithObjectsAndKeys: group_id,@"group_id",  user_id, @"user_id", pk_group_user, @"pk_group_user", nil]
                                andRequestType:kGetScheduleByGroupID];
}

//更新聚会的参与信息
+ (NSMutableDictionary *)updateScheduleDic: (Model_Party_User *)relation {
    return [SRNet_Manager toRequestDicWithData:relation.keyValues
                                andRequestType:kUpdateSchedule];
}


//读取聚会所有的参与信息
+ (NSMutableDictionary *)getPartyRelationshipDic: (Model_Party *)party {
    return [SRNet_Manager toRequestDicWithData:party.keyValues
                                andRequestType:kGetPartyRelationship];
}

//保存上传图片信息
+ (NSMutableDictionary *)addImageToGroupDic: (Model_Photo *)photo {
    return [SRNet_Manager toRequestDicWithData:photo.keyValues
                                andRequestType:kAddImageToGroup];
}

//读取群相册
+ (NSMutableDictionary *)getPhotoByGroupDic: (Model_Group *)group {
    return [SRNet_Manager toRequestDicWithData:group.keyValues
                                andRequestType:kGetPhotoByGroup];
}

//加入小组
+ (NSMutableDictionary *)joinGroupDic: (Model_Group_User *)rel {
    return [SRNet_Manager toRequestDicWithData:rel.keyValues
                                andRequestType:kJoinGroup];
}

//更新与小组关系
+ (NSMutableDictionary *)updateGroupRelationShip: (Model_Group_User *)rel {
    return [SRNet_Manager toRequestDicWithData:rel.keyValues
                                andRequestType:kUpdateGroupRelationShip];
}

//读取用户的小组关系
+ (NSMutableDictionary *)getGroupRelationshipDic: (Model_Group_User *)rel {
    return [SRNet_Manager toRequestDicWithData:rel.keyValues
                                andRequestType:kGetGroupRelationship];
}

//读取用户信息
+ (NSMutableDictionary *)getUserInfoDic: (Model_User *)user {
    return [SRNet_Manager toRequestDicWithData:user.keyValues
                                andRequestType:kGetUserInfo];
}

//保存用户信息
+ (NSMutableDictionary *)updateUserInfoDic: (Model_User *)user {
    return [SRNet_Manager toRequestDicWithData:user.keyValues
                                andRequestType:kUpdateUserInfo];
}


//读取小组中的所有成员关系
+ (NSMutableDictionary *)getAllRelationFromGroupDic: (Model_Group *)group {
    return [SRNet_Manager toRequestDicWithData:group.keyValues
                                andRequestType:kGetAllRelationFromGroup];
}

//请求服务器发送验证码
+ (NSMutableDictionary *)sendVerificationCodeDic: (NSString *)phoneNum {
    return [SRNet_Manager toRequestDicWithData:[[NSDictionary alloc] initWithObjectsAndKeys: phoneNum, @"phone", nil]
                                 andRequestType:kSendVerificationCode];
}

//根据手机号码查找好友
+ (NSMutableDictionary *)getUserByPhoneDic: (Model_User *)user {
    return [SRNet_Manager toRequestDicWithData:user.keyValues
                                andRequestType:kGetUserByPhone];
}

//添加好友
+ (NSMutableDictionary *)addFriendDic: (Model_user_user *)userRelation {
    return [SRNet_Manager toRequestDicWithData:userRelation.keyValues
                                andRequestType:kAddFriend];
}


//读取好友关系
+ (NSMutableDictionary *)getFriendListDic: (Model_User *)user {
    return [SRNet_Manager toRequestDicWithData:user.keyValues
                                andRequestType:kGetFriendList];
}

+ (NSMutableDictionary *)matchPhonesDic: (NSMutableArray *)phones {
    return [SRNet_Manager toRequestDicWithData:
             [[NSDictionary alloc] initWithObjectsAndKeys: phones, @"phones",
              [Model_User loadFromUserDefaults].pk_user, @"user_id", nil]
                                andRequestType:kMatchPhones];
}

+ (NSMutableDictionary *)becomeFriendDic: (Model_user_user *)userRelation {
    return [SRNet_Manager toRequestDicWithData:userRelation.keyValues
                                andRequestType:kBecomeFriend];
}

+ (NSMutableDictionary *)checkRelationDic: (Model_user_user *)userRelation {
    return [SRNet_Manager toRequestDicWithData:userRelation.keyValues
                                andRequestType:kCheckRelation];
}

+ (NSMutableDictionary *)addUserChatDic: (Model_User_Chat *)userChat {
    return [SRNet_Manager toRequestDicWithData:userChat.keyValues
                                andRequestType:kAddUserChat];
}

+ (NSMutableDictionary *)getUserChat: (Model_user_user *)userRelation {
    return [SRNet_Manager toRequestDicWithData:userRelation.keyValues
                                andRequestType:kGetUserChat];
}

//检查昵称重复性
+ (NSMutableDictionary *)checkAccountDic: (Model_User *)user {
    return [SRNet_Manager toRequestDicWithData:user.keyValues
                                andRequestType:kCheckAccount];
}

+ (NSMutableDictionary *)loginAccountDic: (Model_User *)user {
    return [SRNet_Manager toRequestDicWithData:user.keyValues
                                andRequestType:kLoginAccount];
}

//用户回馈
+ (NSMutableDictionary *)feedBackMessageDic: (Model_Feedback *)feedback {
    return [SRNet_Manager toRequestDicWithData:feedback.keyValues
                                andRequestType:kFeedBackMessage];
}
//删除用户关系
+ (NSMutableDictionary *)removeFriendDic: (Model_user_user *)relation {
    return [SRNet_Manager toRequestDicWithData:relation.keyValues
                                andRequestType:kRemoveFriend];
}

//删除图片
+ (NSMutableDictionary *)removePhotoDic: (Model_Photo *)photo {
    return [SRNet_Manager toRequestDicWithData:photo.keyValues
                                andRequestType:kRemovePhoto];
}


+ (NSMutableDictionary *)createRelationshipForPartyDic: (Model_Party_User *)relation {
    return [SRNet_Manager toRequestDicWithData:relation.keyValues
                                andRequestType:kCreateRelationForParty];
}


+ (NSMutableDictionary *)cancelPartyDic: (Model_Party *)party {
    return [SRNet_Manager toRequestDicWithData:party.keyValues
                                andRequestType:kCancelParty];
}


+ (NSMutableDictionary *)sharePartyDic: (Model_Party *)party {
    return [SRNet_Manager toRequestDicWithData:party.keyValues
                                andRequestType:kShareParty];
}

+ (NSMutableDictionary *)imageManagerSignDic {
    return [SRNet_Manager toRequestDicWithData:[NSDictionary dictionaryWithObjectsAndKeys:@"a",@"b",nil]
                                andRequestType:kImageManagerSign];
}


+ (NSMutableDictionary *)testInterfaceDic {
    return [SRNet_Manager toRequestDicWithData:[NSDictionary dictionaryWithObjectsAndKeys:@"jim",@"name",nil]
                                andRequestType:kTestInterface];
}

+ (NSMutableDictionary *)getUserInfoByWechatDic: (Model_User *)user {
    return [SRNet_Manager toRequestDicWithData:user.keyValues
                                andRequestType:kGetUserInfoByWechat];
}

+ (NSMutableDictionary *)getCreatedPartyByUserDic: (Model_User *)user {
    return [SRNet_Manager toRequestDicWithData:user.keyValues
                                andRequestType:kGetCreatedParty];
}

+ (NSMutableDictionary *)getPartyHistoryByUserDic: (Model_User *)user {
    return [SRNet_Manager toRequestDicWithData:user.keyValues
                                andRequestType:kGetPartyHistory];
}

+ (NSMutableDictionary *)updatePartyRelationships: (NSMutableArray *)partyRelationAry {
    NSMutableArray *relationAry = [[NSMutableArray alloc] init];
    for (Model_Party_User *relation in partyRelationAry) {
        [relationAry addObject:relation.keyValues];
    }
    return [SRNet_Manager toRequestDicWithData:
            [[NSDictionary alloc] initWithObjectsAndKeys: relationAry, @"partyRelationships",
             [Model_User loadFromUserDefaults].pk_user, @"user_id", nil]
                                andRequestType:kUpdatePartyRelationships];
}

@end
