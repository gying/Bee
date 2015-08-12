//
//  GroupHistroyPartyViewController.m
//  Agree
//
//  Created by Agree on 15/8/10.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "GroupHistroyPartyViewController.h"
#import "CD_Party.h"

#import "SchedulePartyTableViewDelegate.h"
#import "GroupHistroyPartyTableViewController.h"

#import <MJRefresh.h>

#import "PartyDetailViewController.h"

#define AgreeBlue [UIColor colorWithRed:82/255.0 green:213/255.0 blue:204/255.0 alpha:1.0]
@interface GroupHistroyPartyViewController ()<SRPartyDetailDelegate> {
    NSDictionary *norDic;
    NSDictionary *selDic;
    


    GroupHistroyPartyTableViewController * _groupHistroyDelegate;
    
    BOOL _firstLoadingDone;
}

@end

@implementation GroupHistroyPartyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    _groupHistroyDelegate = [[GroupHistroyPartyTableViewController alloc] init];
    _groupHistroyDelegate.rootController = self;
    self.myGroupHistroyPartyTableView.delegate = _groupHistroyDelegate;
    self.myGroupHistroyPartyTableView.dataSource = _groupHistroyDelegate;
    [_groupHistroyDelegate loadPartyData];
    

    
//     设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    self.myGroupHistroyPartyTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:_groupHistroyDelegate
                                                                       refreshingAction:@selector(loadPartyData)];

    self.textLabel1.backgroundColor = [UIColor clearColor];
    self.textLabel1.text = @"请添加日程";
    self.textLabel1.textColor = AgreeBlue;
    self.textLabel1.textAlignment = NSTextAlignmentCenter;
    self.textLabel1.font = [UIFont systemFontOfSize:14];

    
    if (0 != _groupHistroyDelegate.schAry.count) {
        NSLog(@"当没有创建的聚会时");
        self.backView1.hidden = YES;
    }
    
   }





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)tapBackButton:(id)sender {

    NSLog(@"返回");
     [self.navigationController popViewControllerAnimated:YES];
}


- (void)reloadTipView: (NSInteger)aryCount withType:(int)inttype {
    //1 创建的聚会
    //2 聚会的历史记录
    
    if (0 == aryCount) {
        switch (inttype) {
            case 1: {
                [self.backView1 setHidden:NO];
            }
                break;
            case 2: {
                
            }
                break;
            default:
                break;
        }
    }else {
        switch (inttype) {
            case 1: {
                [self.backView1 setHidden:YES];
            }
                break;
            case 2: {
                
            }
                break;
            default:
                break;
        }
       
    }
}

- (void)detailChange: (Model_Party *)party with:(int)type
{
    switch (type) {
        case 1: {
            //日程
            for (Model_Party *theParty in _groupHistroyDelegate.schAry) {
                if ([theParty.pk_party isEqualToString:party.pk_party]) {
                    theParty.relationship = party.relationship;
                }
            }
            [self.myGroupHistroyPartyTableView reloadData];
        }
            break;
                default:
            break;
    }

}


- (void)cancelParty: (Model_Party *)party with:(int)type
{
    Model_Party *cancelParty;
    switch (type) {
        case 1: {
            //日程
            cancelParty = nil;
            for (Model_Party *theParty in _groupHistroyDelegate.schAry) {
                if ([theParty.pk_party isEqualToString:party.pk_party]) {
                    cancelParty = theParty;
                }
            }
            
            if (cancelParty) {
                [_groupHistroyDelegate.schAry removeObject:cancelParty];
                [self reloadTipView:_groupHistroyDelegate.schAry.count withType:1];
                [self.myGroupHistroyPartyTableView reloadData];
            }
        }
            break;
        default:
            break;
    }

}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    //1 日程
    //2 历史聚会
    //intoType
    if ([@"GroupHistroyParty" isEqualToString:segue.identifier]) {
        PartyDetailViewController *childController = (PartyDetailViewController *)segue.destinationViewController;
        childController.party = [_groupHistroyDelegate.schAry objectAtIndex:self.chooseRow];
        childController.intoType = 1;
        childController.delegate = self;
        
    }
}





@end
