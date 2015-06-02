//
//  GroupDetailViewController.h
//  SRAgree
//
//  Created by G4ddle on 14/12/16.
//  Copyright (c) 2014年 G4ddle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model_Group.h"
#import "Model_Party.h"
#import "Model_Photo.h"
#import "SRAccountView.h"


@interface GroupDetailViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, strong)Model_Group *group;
@property (weak, nonatomic) IBOutlet UITabBar *groupTabBar;
@property (weak, nonatomic) IBOutlet UITabBarItem *groupTalk;
@property (weak, nonatomic) IBOutlet UITabBarItem *groupSchedule;
@property (weak, nonatomic) IBOutlet UITabBarItem *groupPhotos;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view1Width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view2Width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view3Width;
@property (weak, nonatomic) IBOutlet UIScrollView *groupScrollView;

@property (weak, nonatomic) IBOutlet UIView *groupTalkView;

@property (weak, nonatomic) IBOutlet UITableView *chatTableView;

@property (weak, nonatomic) IBOutlet UITableView *partyTableView;

@property (weak, nonatomic) IBOutlet UICollectionView *albumsCollectionView;
@property (nonatomic, strong)Model_Party *chooseParty;

@property (nonatomic, strong)SRAccountView *accountView;


- (void)receiveParty;
- (void)showImageAtIndexPath:(int)indexPath withImageArray: (NSMutableArray *)imageViewArray;

@property BOOL partyLoadingAgain;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectLineWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectConLeft;

@end
