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
//#import "GroupChatTableViewCell.h"

#import <MMDrawerController.h>




@interface GroupDetailViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, strong)Model_Group *group;
@property (weak, nonatomic) IBOutlet UINavigationItem *bar;
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


@property (weak, nonatomic) IBOutlet UILabel *view2Label;

@property (weak, nonatomic) IBOutlet UILabel *view3Label;

@property (weak, nonatomic) IBOutlet UIView *backView2;


@property (weak, nonatomic) IBOutlet UIView *backView3;



@property (nonatomic, strong)Model_Party *chooseParty;
@property (nonatomic, strong)SRAccountView *accountView;


- (void)receiveParty;
- (void)showImageAtIndexPath:(int)indexPath withImageArray: (NSMutableArray *)imageViewArray;

- (void)longTapCell;

- (void)popController ;

@property BOOL partyLoadingAgain;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectLineWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectConLeft;
@property (weak, nonatomic) IBOutlet UIButton *peopleButton;
@property (weak, nonatomic) IBOutlet UIView *rightSideView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightSideViewCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightSideViewWidth;

@property (weak, nonatomic) IBOutlet UIButton *tapCloseButton;

@property (weak, nonatomic) IBOutlet UITableView *peopleTableView;

- (IBAction)tapCloseButton:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *peopleTableViewWidthCon;



@end
