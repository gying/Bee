//
//  GroupPeopleCollectionViewCell.h
//  Agree
//
//  Created by G4ddle on 15/4/30.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model_Group_User.h"
#import "TXYDownloader.h"

@interface GroupPeopleCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;

- (void)initWithGroupUser: (Model_Group_User *)group_user;

@end
