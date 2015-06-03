//
//  SRNet_Manager.m
//  SRAgree
//
//  Created by G4ddle on 14/12/24.
//  Copyright (c) 2014年 G4ddle. All rights reserved.
//

#import "SRNet_Manager.h"
#import "ProgressHUD.h"
#import "AFNetworking.h"
#import "MJExtension.h"

@implementation SRNet_Manager {
    UIViewController *_theDelegate;
}

- (id)initWithDelegate: (id<SRNetManagerDelegate>)delegate {
    self.delegate = delegate;
    return [super init];
}

- (BOOL)requestNetorkWithDic:(NSMutableDictionary *)sendDic {
    
    [ProgressHUD show:@"正在读取中"];
    
    if ([self.delegate isKindOfClass:[UIViewController class]]) {
        if ([_theDelegate isKindOfClass:[UIViewController class]]) {
            _theDelegate = (UIViewController *)self.delegate;
            _theDelegate.view.userInteractionEnabled = NO;
            _theDelegate.navigationController.view.userInteractionEnabled = NO;
            _theDelegate.tabBarController.view.userInteractionEnabled = NO;
        }
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", kBaseUrlString, kInterfaceUrlString];
    
    
    //    NSLog(string);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    
    NSLog(@"%@",sendDic);
    
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",nil];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    [manager POST:urlString parameters:sendDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSMutableDictionary *dic = responseObject;
        if (!responseObject) {
            //如果返回对象不存在
        }
        
        if (![dic  objectForKey:@"statusMsg"]) {
            //如果返回信息码不存在
        } else {
            NSNumber *statusNum = [dic  objectForKey:@"statusMsg"];
            if (0 == statusNum.intValue) {
                [self.delegate interfaceReturnDataSuccess:nil with:[(NSNumber *)[dic  objectForKey:@"interface"] intValue]];
            } else {
                if ([dic objectForKey:@"returnData"]) {
                    //返回数据存在
                    [self.delegate interfaceReturnDataSuccess:[dic objectForKey:@"returnData"]  with:[(NSNumber *)[dic  objectForKey:@"interface"] intValue]];
                }else {
                    //返回数据不存在
                }                
            }
        }
        
        
        if ([self.delegate isKindOfClass:[UIViewController class]]) {
            _theDelegate.view.userInteractionEnabled = YES;
            _theDelegate.navigationController.view.userInteractionEnabled = YES;
            _theDelegate.tabBarController.view.userInteractionEnabled = YES;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self.delegate interfaceReturnDataError: [(NSNumber *)[sendDic objectForKey:@"request_type"] intValue]];
        if ([self.delegate isKindOfClass:[UIViewController class]]) {
            _theDelegate.view.userInteractionEnabled = YES;
            _theDelegate.navigationController.view.userInteractionEnabled = YES;
            _theDelegate.tabBarController.view.userInteractionEnabled = YES;
        }
//        [ProgressHUD showError:@"网络错误"];
    }];
    return TRUE;
    
//    NSURL *postUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kBaseUrlString, kInterfaceUrlString]];
//    
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:postUrl
//                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
//                                                           timeoutInterval:10];
//    [request setHTTPMethod:@"post"];
//    
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:sendDic
//                                                       options:NSJSONWritingPrettyPrinted
//                                                         error:nil];
//    [request setHTTPBody:jsonData];
//    
////    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
//    
//    
//    NSURLResponse * response;
//    NSError * error;
//    NSData * backData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//    
//    if (error) {
//        NSLog(@"error : %@",[error localizedDescription]);
//    }else{
//        NSLog(@"response : %@",response);
//        NSLog(@"backData : %@",[[NSString alloc]initWithData:backData encoding:NSUTF8StringEncoding]);
//    }
    
    
    return TRUE;
}

// 将字典或者数组转化为JSON串
- (NSData *)toJSONData:(id)theData{
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

- (NSMutableDictionary *)toRequestDicWithData: (id)requestData andRequestType:(int)requestType {
    NSMutableDictionary *requestDic = [[NSMutableDictionary alloc] init];
    
    [requestDic setObject:[NSNumber numberWithInt:requestType] forKey:@"request_type"];
    if ([requestData isKindOfClass:[NSDictionary class]]) {
        //如果数据为数组
        [requestDic setObject:[[NSString alloc] initWithData:[self toJSONData:requestData] encoding:NSUTF8StringEncoding] forKey:@"request_data"];
    } else {
        //如果数据为字符串 (暂定二重判断)
        [requestDic setObject:[[NSString alloc] initWithData:[self toJSONData:requestData] encoding:NSUTF8StringEncoding] forKey:@"request_data"];
    }
    
    return requestDic;
}
//增加小组
- (BOOL)addGroup: (Model_Group *)newGroup withMembers: (NSMutableArray *)members {
    
    NSMutableDictionary *newGroupDic = [[NSMutableDictionary alloc] init];
    [newGroupDic setValue:newGroup.keyValues forKey:@"group"];
    
    NSMutableArray *newUserAry = [[NSMutableArray alloc] init];
    for (Model_Group_User *group_user in members) {
        [newUserAry addObject:group_user.keyValues];
    }
    [newGroupDic setValue:newUserAry forKey:@"member"];
    
    return [self requestNetorkWithDic:[self toRequestDicWithData:newGroupDic andRequestType:31]];
}

//注册用户
- (BOOL)regUser: (Model_User *)newUser {
    return [self requestNetorkWithDic:[self toRequestDicWithData:newUser.keyValues
                                                  andRequestType:11]];
}

//获取用户的小组信息
- (BOOL)getUserGroups: (Model_User *)user {
    return [self requestNetorkWithDic:[self toRequestDicWithData:user.keyValues
                                                  andRequestType:32]];
}


//获取小组的聊天信息
- (BOOL)getChatMessageByGroup: (Model_Group *)group {
    return [self requestNetorkWithDic:[self toRequestDicWithData:group.keyValues
                                                  andRequestType:51]];
}

//增加一条聊天信息
- (BOOL)addChatMessageToGroup: (Model_Chat *)chat {
    return [self requestNetorkWithDic:[self toRequestDicWithData:chat.keyValues
                                                  andRequestType:52]];
}

//添加一条行程
- (BOOL)addSchedule: (Model_Party *)party {
    return [self requestNetorkWithDic:[self toRequestDicWithData:party.keyValues
                                                  andRequestType:47]];
}

//读取用户下所有的聚会信息
- (BOOL)getAllScheduleByUser: (Model_User *)user {
    return [self requestNetorkWithDic:[self toRequestDicWithData:user.keyValues
                                                  andRequestType:41]];
}

//返回小组邀请码
- (BOOL)generationCodeByGroup: (Model_Group *)group {
    return [self requestNetorkWithDic:[self toRequestDicWithData:group.keyValues
                                                  andRequestType:37]];
}

//使用邀请码加入小组
- (BOOL)joinTheGroupByCode: (Model_Group_Code *)code {
    return [self requestNetorkWithDic:[self toRequestDicWithData:code.keyValues
                                                  andRequestType:38]];
}

//读取小组聚会列表
- (BOOL)getScheduleByGroupID: (NSNumber *)group_id withUserID: (NSNumber *)user_id withRelID: (NSNumber *)pk_group_user {
    return [self requestNetorkWithDic:[self toRequestDicWithData:[[NSDictionary alloc] initWithObjectsAndKeys: group_id,@"group_id",  user_id, @"user_id", pk_group_user, @"pk_group_user", nil]
                                                  andRequestType:43]];
}

//更新聚会的参与信息
- (BOOL)updateSchedule: (Model_Party_User *)relation {
    return [self requestNetorkWithDic:[self toRequestDicWithData:relation.keyValues
                                                  andRequestType:45]];
}

//读取聚会所有的参与信息
- (BOOL)getPartyRelationship: (Model_Party *)party {
    return [self requestNetorkWithDic:[self toRequestDicWithData:party.keyValues
                                                  andRequestType:48]];
}

//保存上传图片信息
- (BOOL)addImageToGroup: (Model_Photo *)photo {
    return [self requestNetorkWithDic:[self toRequestDicWithData:photo.keyValues
                                                  andRequestType:62]];
}

//读取群相册
- (BOOL)getPhotoByGroup: (Model_Group *)group {
    return [self requestNetorkWithDic:[self toRequestDicWithData:group.keyValues
                                                  andRequestType:61]];
}

//加入小组
- (BOOL)joinGroup: (Model_Group_User *)rel {
    return [self requestNetorkWithDic:[self toRequestDicWithData:rel.keyValues
                                                  andRequestType:39]];
}

//更新与小组关系
- (BOOL)updateGroupRelationShip: (Model_Group_User *)rel {
    return [self requestNetorkWithDic:[self toRequestDicWithData:rel.keyValues
                                                  andRequestType:34]];
}

//读取用户的小组关系
- (BOOL)getGroupRelationship: (Model_Group_User *)rel {
    return [self requestNetorkWithDic:[self toRequestDicWithData:rel.keyValues
                                                  andRequestType:33]];
}

//读取用户信息
- (BOOL)getUserInfo: (Model_User *)user {
    return [self requestNetorkWithDic:[self toRequestDicWithData:user.keyValues
                                                  andRequestType:17]];
}

//保存用户信息
- (BOOL)updateUserInfo: (Model_User *)user {
    return [self requestNetorkWithDic:[self toRequestDicWithData:user.keyValues
                                                  andRequestType:15]];
}

//读取小组中的所有成员关系
- (BOOL)getAllRelationFromGroup: (Model_Group *)group {
    return [self requestNetorkWithDic:[self toRequestDicWithData:group.keyValues
                                                  andRequestType:36]];
}

//请求服务器发送验证码
- (BOOL)sendVerificationCode: (NSString *)phoneNum {
    return [self requestNetorkWithDic:
            [self toRequestDicWithData:[[NSDictionary alloc] initWithObjectsAndKeys: phoneNum, @"phone", nil]
                                                                     andRequestType:18]];
}

//根据手机号码查找好友
- (BOOL)getUserByPhone: (Model_User *)user {
    
    return [self requestNetorkWithDic:[self toRequestDicWithData:user.keyValues
                                                  andRequestType:19]];
}

//添加好友
- (BOOL)addFriend: (Model_user_user *)userRelation {
    if ([userRelation.fk_user_to isEqualToNumber:[Model_User loadFromUserDefaults].pk_user]) {
        //自己加自己 则直接返回
        return FALSE;
    } else {
        return [self requestNetorkWithDic:[self toRequestDicWithData:userRelation.keyValues
                                                      andRequestType:71]];
    }
}

//读取好友关系
- (BOOL)getFriendList: (Model_User *)user {
    return [self requestNetorkWithDic:[self toRequestDicWithData:user.keyValues
                                                  andRequestType:72]];
}

- (BOOL)matchPhones: (NSMutableArray *)phones {
    return [self requestNetorkWithDic:
            [self toRequestDicWithData:
             [[NSDictionary alloc] initWithObjectsAndKeys: phones, @"phones",
              [Model_User loadFromUserDefaults].pk_user, @"user_id", nil] andRequestType:73]];
}

- (BOOL)becomeFriend: (Model_user_user *)userRelation {
    return [self requestNetorkWithDic:[self toRequestDicWithData:userRelation.keyValues
                                                  andRequestType:74]];
}

- (BOOL)checkRelation: (Model_user_user *)userRelation {
    return [self requestNetorkWithDic:[self toRequestDicWithData:userRelation.keyValues
                                                  andRequestType:75]];
}

- (BOOL)addUserChat: (Model_User_Chat *)userChat {
    return [self requestNetorkWithDic:[self toRequestDicWithData:userChat.keyValues
                                                  andRequestType:81]];
}

- (BOOL)getUserChat: (Model_user_user *)userRelation {
    return [self requestNetorkWithDic:[self toRequestDicWithData:userRelation.keyValues
                                                  andRequestType:82]];
}

//检查昵称重复性
- (BOOL)checkAccount: (Model_User *)user {
    return [self requestNetorkWithDic:[self toRequestDicWithData:user.keyValues
                                                  andRequestType:111]];
}

- (BOOL)loginAccount: (Model_User *)user {
    return [self requestNetorkWithDic:[self toRequestDicWithData:user.keyValues
                                                  andRequestType:12]];
}

//用户回馈
- (BOOL)feedBackMessage: (Model_Feedback *)feedback {
    return [self requestNetorkWithDic:[self toRequestDicWithData:feedback.keyValues
                                                  andRequestType:91]];
}
//删除用户关系
- (BOOL)removeFriend: (Model_user_user *)relation {
    return [self requestNetorkWithDic:[self toRequestDicWithData:relation.keyValues
                                                  andRequestType:76]];
}

//删除图片
- (BOOL)removePhoto: (Model_Photo *)photo {
    return [self requestNetorkWithDic:[self toRequestDicWithData:photo.keyValues
                                                  andRequestType:63]];
}

- (BOOL)createRelationshipForParty: (Model_Party_User *)relation {
    return [self requestNetorkWithDic:[self toRequestDicWithData:relation.keyValues
                                                  andRequestType:49]];
}

- (BOOL)cancelParty: (Model_Party *)party {
    return [self requestNetorkWithDic:[self toRequestDicWithData:party.keyValues
                                                  andRequestType:kCancelParty]];
}

- (BOOL)imageManagerSign {
    return [self requestNetorkWithDic:[self toRequestDicWithData:[NSDictionary dictionaryWithObjectsAndKeys:@"a",@"b",nil]
                                                  andRequestType:kImageManagerSign]];
}


- (BOOL)testInterface {
    return [self requestNetorkWithDic:[self toRequestDicWithData:[NSDictionary dictionaryWithObjectsAndKeys:@"jim",@"name",nil]
                                                  andRequestType:kTestInterface]];
}

@end
