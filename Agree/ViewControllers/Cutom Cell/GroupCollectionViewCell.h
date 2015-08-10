//
//  GroupCollectionViewCell.h
//  Agree
//
//  Created by G4ddle on 15/2/14.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model_Group.h"

@interface GroupCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *groupImageView;
@property (weak, nonatomic) IBOutlet UILabel *groupNameLabel;
@property (weak, nonatomic) IBOutlet UIView *groupView;
@property (weak, nonatomic) IBOutlet UIView *group2ndView;
@property (weak, nonatomic) IBOutlet UIView *statusView;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property BOOL initDone;
@property BOOL chatUpdate;

- (void)initCellWithGroup: (Model_Group *)group isAddView: (BOOL)isAddView;
- (void)initAddView;

@end
