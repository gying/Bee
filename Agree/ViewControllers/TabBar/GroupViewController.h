//
//  GroupViewController.h
//  Agree
//
//  Created by G4ddle on 15/2/14.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRNet_Manager.h"
#import "TXYDownloader.h"

@interface GroupViewController : UIViewController

@property (nonatomic, strong)Model_Group *joinGroup;
@property BOOL needPublicPhone;
@property (weak, nonatomic) IBOutlet UICollectionView *groupCollectionView;
@property BOOL dataChange;

@property (weak, nonatomic) IBOutlet UIButton *createButton;

@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;

@property (weak, nonatomic) IBOutlet UITextField *codeInputTextField;
//@property (weak, nonatomic) IBOutlet UIButton *groupCoverButton;
@property (weak, nonatomic) IBOutlet UIImageView *groupCoverImageView;
@property (weak, nonatomic) IBOutlet UILabel *groupNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *recodeButton;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;

@property (weak, nonatomic) IBOutlet UILabel *publicPhoneLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *publicPhoneSeg;

@property (nonatomic, strong)NSArray *groupAry;


- (void)joinGroupRelation;
- (void)loadUserGroupRelationship;

- (void)cleanAllPartyUpdate ;
//小组的聊天信息+1
- (void)addGroupChatUpdateStatus: (NSString *)em_id;

//小组的聚会信息+1
- (void)addGroupPartyUpdateStatus: (NSNumber *)pk_group;
@property (weak, nonatomic) IBOutlet UIView *codeView;

- (void)intoChatView;




@end
