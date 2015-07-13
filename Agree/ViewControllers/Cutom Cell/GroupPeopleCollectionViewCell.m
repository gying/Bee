//
//  GroupPeopleCollectionViewCell.m
//  Agree
//
//  Created by G4ddle on 15/4/30.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "GroupPeopleCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "SRImageManager.h"

@implementation GroupPeopleCollectionViewCell

- (void)initWithGroupUser: (Model_Group_User *)group_user {
    [self.avatarImageView.layer setCornerRadius:self.avatarImageView.frame.size.width/2];
    [self.avatarImageView.layer setMasksToBounds:YES];
//    [self.avatarImageView sd_setImageWithURL:[SRImageManager avatarImageFromTXYFieldID:group_user.avatar_path]];
    
    //下载图片
    NSURL *imageUrl = [SRImageManager avatarImageFromTXYFieldID:group_user.avatar_path];
//    NSString * urlstr = [imageUrl absoluteString];
//    
//    NSData *imageData = [[TXYDownloader sharedInstanceWithPersistenceId:nil] getCacheData:urlstr];
//    if (imageData) {
//        [self.avatarImageView setImage:[UIImage imageWithData:imageData]];
//    }else{
//    
//    [[TXYDownloader sharedInstanceWithPersistenceId:nil]download:urlstr target:self.avatarImageView succBlock:^(NSString *url, NSData *data, NSDictionary *info) {
//        [self.avatarImageView setImage:[UIImage imageWithContentsOfFile:[info objectForKey:@"filePath"]]];
//    } failBlock:nil progressBlock:nil param:nil];
//    }
    [self.avatarImageView sd_setImageWithURL:imageUrl];
    [self.nicknameLabel setText:group_user.nickname];
    
//    switch (group_user.role.intValue) {
//        case 1: {
//            [self.statusLabel setText:@"神奇的组长"];
//        }
//            break;
//            
//        case 2: {
//            [self.statusLabel setText:@"普通成员"];
//        }
//            break;
//            
//        default:
//            break;
//    }
}

@end
