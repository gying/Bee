//
//  PartyPeopleListViewController.m
//  Agree
//
//  Created by G4ddle on 15/2/25.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "PartyPeopleListViewController.h"
#import "Model_User.h"
#import "PeopleListTableViewCell.h"
#import "SRNet_Manager.h"

#define AgreeBlue [UIColor colorWithRed:82/255.0 green:213/255.0 blue:204/255.0 alpha:1.0]

@interface PartyPeopleListViewController () <UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate,UIActionSheetDelegate> {
    NSMutableArray *_inArray;
    NSMutableArray *_outArray;
    NSMutableArray *_unknowArray;
    NSMutableArray *_showArray;
    
    NSMutableArray *_tempInArray;
    BOOL _inArrayIsChange;
}

@end

@implementation PartyPeopleListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setRelationData];
    
    [self.inButton.layer setCornerRadius:self.inButton.frame.size.height/2];
    [self.outButton.layer setCornerRadius:self.outButton.frame.size.height/2];
    [self.unknowButton.layer setCornerRadius:self.unknowButton.frame.size.height/2];
    
    [self.inLabel setText:[NSString stringWithFormat:@"%d", (int)_inArray.count]];
    [self.outLabel setText:[NSString stringWithFormat:@"%d", (int)_outArray.count]];
    [self.unknowLabel setText:[NSString stringWithFormat:@"%d", (int)_unknowArray.count]];
    
    [self.peoplesTableview setDelegate:self];
    [self.peoplesTableview setDataSource:self];
    
    switch (self.showStatus) {
        case 1:{
            [self pressedTheInButton:Nil];
            _showArray = _inArray;
        }
            break;
            
        case 2: {
            [self pressedTheOutButton:Nil];
            _showArray = _outArray;
        }
            break;
            
        case 3: {
            [self pressedTheUnknowButton:Nil];
            _showArray = _unknowArray;
        }
            break;
            
        default:
            break;
    }
    
    _tempInArray = [[NSMutableArray alloc] initWithArray:_inArray];
    
}

- (void)setRelationData {
    _inArray = [[NSMutableArray alloc] init];
    _outArray = [[NSMutableArray alloc] init];
    _unknowArray = [[NSMutableArray alloc] init];
    if (self.relationArray) {
        
        for (Model_User *theUser in self.relationArray) {
            switch ([theUser.relationship intValue]) {
                case 1: {
                    //参与用户
                    [_inArray addObject:theUser];
                }
                    break;
                case 2: {
                    //拒绝用户
                    [_outArray addObject:theUser];
                }
                    break;
                case 0: {
                    //未表态用户
                    [_unknowArray addObject:theUser];
                }
                    break;
                default:
                    break;
            }
        }
    }
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    
}

- (IBAction)pressedTheInButton:(id)sender {
    
    self.showStatus = 1;
    
    [self resetAllButton];
    [self.inButton setBackgroundColor:AgreeBlue];
    [self.inButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.inLabel setTextColor:[UIColor whiteColor]];
    
    _showArray = _inArray;
    [self.peoplesTableview reloadData];
}
- (IBAction)pressedTheUnknowButton:(id)sender {
    self.showStatus = 2;
    
    [self resetAllButton];
    [self.unknowButton setBackgroundColor:AgreeBlue];
    [self.unknowButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.unknowLabel setTextColor:[UIColor whiteColor]];
    
    _showArray = _unknowArray;
    [self.peoplesTableview reloadData];
}
- (IBAction)pressedTheOutButton:(id)sender {
    self.showStatus = 3;
    [self resetAllButton];
    [self.outButton setBackgroundColor:AgreeBlue];
    [self.outButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.outLabel setTextColor:[UIColor whiteColor]];
    
    _showArray = _outArray;
    [self.peoplesTableview reloadData];
}

- (void)resetAllButton {
    [self.inButton setBackgroundColor:[UIColor clearColor]];
    [self.inButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.inLabel setTextColor:AgreeBlue];
    
    
    [self.outButton setBackgroundColor:[UIColor clearColor]];
    [self.outButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.outLabel setTextColor:AgreeBlue];
    
    [self.unknowButton setBackgroundColor:[UIColor clearColor]];
    [self.unknowButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.unknowLabel setTextColor:AgreeBlue];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_showArray) {
        return _showArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Model_User *theUser = [_showArray objectAtIndex:indexPath.row];
    static NSString *CellIdentifier = @"peopleListCell";
    
    PeopleListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil == cell) {
        cell = [[PeopleListTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    [cell initWithUser:theUser withShowStatus:self.showStatus isCreator:self.isCreator];
    return cell;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)tapBackButton:(id)sender {
    
    //首先做是否更改状态的判断
    for (Model_User *tempUser in _tempInArray) {
        for (Model_User *user in _inArray) {
            if (!tempUser.pay_type) {
                tempUser.pay_type = @0;
            }
            if (!(tempUser.pay_type.intValue == user.pay_type.intValue)) {
                //未被改变过
                _inArrayIsChange = YES;
            }
        }
    }
    
    if (_inArrayIsChange) {
        UIActionSheet * actionSheet = [[UIActionSheet alloc]initWithTitle:@"是否保存当前信息"
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:@"保存后退出"
                                                        otherButtonTitles:@"直接退出",nil];
        
        [actionSheet showInView:self.view];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)tapSaveButton:(UIButton *)sender {
    //开始初始化关系数组
    NSMutableArray *relationAry = [[NSMutableArray alloc] init];
    for (Model_User *user in self.relationArray) {
        Model_Party_User *partyRealtion = [[Model_Party_User alloc] init];
        partyRealtion.pk_party_user = user.pk_party_user;
        partyRealtion.pay_type = user.pay_type;
        [relationAry addObject:partyRealtion];
    }
    
    
    //点击保存按钮,开始保存数据
    [SRNet_Manager requestNetWithDic:[SRNet_Manager updatePartyRelationships:relationAry]
                            complete:^(NSString *msgString, id jsonDic, int interType, NSURLSessionDataTask *task) {
                                //保存操作成功
                            } failure:^(NSError *error, NSURLSessionDataTask *task) {
                                
                            }];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: {
            //保存后退出
            
            
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 1: {
            //直接退出
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        default:
            break;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
