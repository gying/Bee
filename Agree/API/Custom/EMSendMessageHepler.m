//
//  EMSendMessageHepler.m
//  Agree
//
//  Created by G4ddle on 15/4/5.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "EMSendMessageHepler.h"
#import "ConvertToCommonEmoticonsHelper.h"

@interface ChatImageOptions : NSObject<IChatImageOptions>

@property (assign, nonatomic) CGFloat compressionQuality;

@end

@implementation ChatImageOptions

@end


@implementation EMSendMessageHepler

+(EMMessage *)sendTextMessageWithString:(NSString *)str
                             toUsername:(NSString *)username
                            isChatGroup:(BOOL)isChatGroup
                      requireEncryption:(BOOL)requireEncryption
                                    ext:(NSDictionary *)ext
{
    // 表情映射。
    NSString *willSendText = [ConvertToCommonEmoticonsHelper convertToCommonEmoticons:str];
    EMChatText *text = [[EMChatText alloc] initWithText:willSendText];
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithChatObject:text];
    return [self sendMessage:username messageBody:body isChatGroup:isChatGroup requireEncryption:requireEncryption ext:ext];
}

+(EMMessage *)sendImageMessageWithImage:(UIImage *)image
                             toUsername:(NSString *)username
                            isChatGroup:(BOOL)isChatGroup
                      requireEncryption:(BOOL)requireEncryption
                                    ext:(NSDictionary *)ext
{
    EMChatImage *chatImage = [[EMChatImage alloc] initWithUIImage:image displayName:@"image.jpg"];
    id <IChatImageOptions> options = [[ChatImageOptions alloc] init];
    [options setCompressionQuality:0.6];
    [chatImage setImageOptions:options];
    EMImageMessageBody *body = [[EMImageMessageBody alloc] initWithImage:chatImage thumbnailImage:nil];
    return [self sendMessage:username messageBody:body isChatGroup:isChatGroup requireEncryption:requireEncryption ext:ext];
}

+(EMMessage *)sendVoice:(EMChatVoice *)voice
             toUsername:(NSString *)username
            isChatGroup:(BOOL)isChatGroup
      requireEncryption:(BOOL)requireEncryption
                    ext:(NSDictionary *)ext
{
    EMVoiceMessageBody *body = [[EMVoiceMessageBody alloc] initWithChatObject:voice];
    return [self sendMessage:username messageBody:body isChatGroup:isChatGroup requireEncryption:requireEncryption ext:ext];
}

+(EMMessage *)sendVideo:(EMChatVideo *)video
             toUsername:(NSString *)username
            isChatGroup:(BOOL)isChatGroup
      requireEncryption:(BOOL)requireEncryption
                    ext:(NSDictionary *)ext
{
    EMVideoMessageBody *body = [[EMVideoMessageBody alloc] initWithChatObject:video];
    return [self sendMessage:username messageBody:body isChatGroup:isChatGroup requireEncryption:requireEncryption ext:ext];
}

+(EMMessage *)sendLocationLatitude:(double)latitude
                         longitude:(double)longitude
                           address:(NSString *)address
                        toUsername:(NSString *)username
                       isChatGroup:(BOOL)isChatGroup
                 requireEncryption:(BOOL)requireEncryption
                               ext:(NSDictionary *)ext
{
    EMChatLocation *chatLocation = [[EMChatLocation alloc] initWithLatitude:latitude longitude:longitude address:address];
    EMLocationMessageBody *body = [[EMLocationMessageBody alloc] initWithChatObject:chatLocation];
    return [self sendMessage:username messageBody:body isChatGroup:isChatGroup requireEncryption:requireEncryption ext:ext];
}

// 发送消息
+(EMMessage *)sendMessage:(NSString *)username
              messageBody:(id<IEMMessageBody>)body
              isChatGroup:(BOOL)isChatGroup
        requireEncryption:(BOOL)requireEncryption
                      ext:(NSDictionary *)ext
{
    EMMessage *retureMsg = [[EMMessage alloc] initWithReceiver:username bodies:[NSArray arrayWithObject:body]];
    retureMsg.requireEncryption = requireEncryption;
    if (isChatGroup) {
//        [retureMsg setMessageType:eMessageTypeGroupChat];
        [retureMsg setIsGroup:YES];
        
    } else {
//        [retureMsg setMessageType:eMessageTypeChat];
        [retureMsg setIsGroup:NO];
    }
    
    retureMsg.ext = ext;
    EMMessage *message = [[EaseMob sharedInstance].chatManager asyncSendMessage:retureMsg progress:nil];
    
    return message;
}

@end
