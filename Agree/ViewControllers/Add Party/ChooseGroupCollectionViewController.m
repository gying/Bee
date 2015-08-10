//
//  ChooseGroupCollectionViewController.m
//  Agree
//
//  Created by G4ddle on 15/4/30.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "ChooseGroupCollectionViewController.h"
#import "GroupCollectionViewCell.h"
#import "AppDelegate.h"
#import "Model_Group.h"
#import "ChooseLoctaionViewController.h"
#import <UIImageView+WebCache.h>
#import "SRImageManager.h"
#import "SRTool.h"

@interface ChooseGroupCollectionViewController () {
    NSArray *_groupAry;
    NSInteger _chooseIndexPath;
}

@end

@implementation ChooseGroupCollectionViewController

static NSString * const reuseIdentifier = @"GroupCollectionCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    if (delegate.groupDelegate.groupAry) {
        _groupAry = delegate.groupDelegate.groupAry;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>

//返回CELL个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_groupAry) {
        return _groupAry.count + 1;
    }
    return 1;
    

}
//CELL内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GroupCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    // Configure the cell
        if (indexPath.row == 0) {
            //第一条信息
            //添加聚会按钮
            [cell initCellWithGroup:nil isAddView:YES];
            cell.groupNameLabel.text = @"添加公共聚会";
            
        } else {
            Model_Group *theGroup = [_groupAry objectAtIndex:indexPath.row-1];

//          EMConversation *conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:theGroup.em_id isGroup:YES];
            [theGroup setChat_update:[NSNumber numberWithInteger:0]];
            [cell initCellWithGroup:theGroup isAddView:NO];
            
            NSURL *imageUrl = [SRImageManager groupFrontCoverImageImageFromOSS:theGroup.avatar_path];
            [cell.groupImageView sd_setImageWithURL:imageUrl
                                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                              [self setGroupAvatar:image atIndex:indexPath];
                                          }];
            
        }

    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _chooseIndexPath = indexPath.row;
    return YES;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    float cellSize = ([UIScreen mainScreen].bounds.size.width - 3)/2;
    return CGSizeMake(cellSize, cellSize);
}

- (void)setGroupAvatar: (UIImage *)image atIndex: (NSIndexPath *)indexPath {
    GroupCollectionViewCell *cell = (GroupCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    [cell.groupImageView setImage:image];
}



#pragma mark - Navigation
//- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
//    if (_chooseIndexPath == self.groupAry.count) {
//        //新建页面
//        [self performSegueWithIdentifier:@"CreateGroup" sender:self];
//        _chooseIndexPath = 0;
//        return NO;
//    }
//    return YES;
//}
- (IBAction)tapBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if (0 == _chooseIndexPath) {
        //添加公共聚会未开放
        [SRTool showSRAlertViewWithTitle:@"提示"
                                 message:@"我们的公开聚会功能还在每日每夜的赶工,请期待~"
                       cancelButtonTitle:@"好的"
                        otherButtonTitle:nil
                   tapCancelButtonHandle:^(NSString *msgString) {
                             
                   } tapOtherButtonHandle:^(NSString *msgString) {
                             
                   }];
        return NO;
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    //读取小组详情数据并赋值小组数据
    ChooseLoctaionViewController *controller = (ChooseLoctaionViewController *)segue.destinationViewController;
    
    if (0 == _chooseIndexPath) {
        controller.chooseGroup = nil;
        
    }else {
        controller.chooseGroup = [_groupAry objectAtIndex:_chooseIndexPath-1];
    }

    controller.isGroupParty = FALSE;
}

@end
