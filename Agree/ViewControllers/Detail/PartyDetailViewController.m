//
//  PartyDetailViewController.m
//  Agree
//
//  Created by G4ddle on 15/1/26.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "PartyDetailViewController.h"
#import "SRNet_Manager.h"
#import "Model_Party_User.h"
#import <SVProgressHUD.h>
#import "MJExtension.h"
#import "SRTool.h"
#import "PartyPeopleListViewController.h"
#import "PartyMapViewController.h"

#import "BMapKit.h"

#define AgreeBlue [UIColor colorWithRed:82/255.0 green:213/255.0 blue:204/255.0 alpha:1.0]

@interface PartyDetailViewController () <SRNetManagerDelegate> {
    SRNet_Manager *_netManager;
    Model_Party_User *_relation;
    NSArray *_relArray;
    int _showStatus;
    BMKMapView *_bdMapView;
}

@end

@implementation PartyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.navigationItem setTitle:self.party.name];
    
    if (self.party.longitude && self.party.latitude) {
        //如果存在经纬度数据
        //则开始更新地区信息
        _bdMapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width - 16, [[UIScreen mainScreen] bounds].size.height - 410)];
        
        self.mapConHeight.constant = CGRectGetHeight(_bdMapView.bounds);
//        [self.locationMapView addSubview:_bdMapView];
        [self.locationMapView insertSubview:_bdMapView atIndex:0];
        
        CLLocationCoordinate2D partyCoor;
        partyCoor.longitude = [self.party.longitude doubleValue];
        partyCoor.latitude = [self.party.latitude doubleValue];
        BMKPointAnnotation *_chooseAnnotation = [[BMKPointAnnotation alloc] init];
        _chooseAnnotation.coordinate = partyCoor;
        _chooseAnnotation.title = @"聚会地点";
        [_bdMapView addAnnotation:_chooseAnnotation];
        [_bdMapView setZoomLevel:15];
        [_bdMapView setCenterCoordinate:partyCoor];
    }
    
    
    //判断是否是创建者本身.
    if ([[Model_User loadFromUserDefaults].pk_user isEqualToNumber:self.party.fk_user]) {
        [self.cancelButton setHidden:NO];
    } else {
        [self.cancelButton setHidden:YES];
    }
    
    self.conHeight.constant = (CGRectGetHeight([UIScreen mainScreen].applicationFrame)-44)*2;
    
    if (self.party.remark) {
        self.remarkTextView.text = self.party.remark;
    }
    
    self.nameLabel.text = self.party.name;
    if (!_netManager) {
        _netManager = [[SRNet_Manager alloc] initWithDelegate:self];
    }
    
    _relation = [[Model_Party_User alloc] init];
    _relation.pk_party_user = self.party.pk_party_user;
    _relation.relationship = self.party.relationship;
    
    _relation.fk_party = self.party.pk_party;
    _relation.fk_user = [Model_User loadFromUserDefaults].pk_user;
    
    [self.yesButton.layer setCornerRadius:self.yesButton.frame.size.height/2];
    [self.yesButton.layer setMasksToBounds:YES];
    
    [self.noButton.layer setCornerRadius:self.noButton.frame.size.height/2];
    [self.noButton.layer setMasksToBounds:YES];
    
    [self.addressLabel setText:self.party.location];
    
    
    NSDate *beginDate = self.party.begin_time;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy年M月d日 EEEE aa hh:mm"];
    [self.beginDateLabel setText:[dateFormatter stringFromDate:beginDate]];
    
    Model_Party *sendParty = [[Model_Party alloc] init];
    sendParty.pk_party = self.party.pk_party;
    
    if (self.party) {
        [_netManager getPartyRelationship:sendParty];
    }
    
    if (nil == self.party.relationship) {
        //在与聚会未产生关系时(第一次进入聚会详情),建立与聚会关系
        _relation.relationship = @0;
        
        if ([self.party.fk_user isEqualToNumber:[Model_User loadFromUserDefaults].pk_user]) {
            _relation.type = @2;
        } else {
            _relation.type = @1;
        }
        
        [_netManager createRelationshipForParty:_relation];
    }
    
    [self setParticipateStatus];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pressedYesButton:(id)sender {
    if (1 == [_relation.relationship intValue]) {
        //取消选中状态
        _relation.relationship = @0;
        self.party.inNum = [NSNumber numberWithInt:[self.party.inNum intValue] - 1];
    } else {
        _relation.relationship = @1;
        self.party.inNum = [NSNumber numberWithInt:[self.party.inNum intValue] + 1];
    }
    
    [_netManager updateSchedule:_relation];
}

- (IBAction)pressedNoButton:(id)sender {
    if (2 == [_relation.relationship intValue]) {
        //取消选中状态
        _relation.relationship = @0;
    } else {
        
        if (1 == _relation.relationship.intValue ) {
            self.party.inNum = [NSNumber numberWithInt:[self.party.inNum intValue] - 1];
        }
        _relation.relationship = @2;
    }
    [_netManager updateSchedule:_relation];
}

- (void)reloadPeopleNum {
    
    int inNum = 0;
    int outNum = 0;
    int unNum = 0;
    
    for (Model_User *user in _relArray) {
        switch ([user.relationship intValue]) {
            case 0: {
                //未表态
                unNum++;
            }
                break;
            case 1: {
                //参与
                inNum++;
            }
                break;
            case 2: {
                //拒绝
                outNum++;
            }
                break;
            default:
                break;
        }
    }
    
    //更新参与人数的标签
    self.inNumLabel.text = [NSString stringWithFormat:@"%d", inNum];
    self.outNumLabel.text = [NSString stringWithFormat:@"%d", outNum];
    self.unkownLabel.text = [NSString stringWithFormat:@"%d", unNum];
}

- (void)setParticipateStatus {
    switch ([_relation.relationship intValue]) {
        case 0: {
            //未选择
            self.yesButton.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
            [self.yesButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            
            self.noButton.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
            [self.noButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
            break;
        case 1: {
            //同意
            self.yesButton.backgroundColor = AgreeBlue;
            [self.yesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            self.noButton.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
            [self.noButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
            break;
        case 2: {
            //拒绝
            self.yesButton.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
            [self.yesButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            
            self.noButton.backgroundColor = AgreeBlue;
            [self.noButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
}

- (IBAction)pressedTheCanelButton:(id)sender {
    //取消聚会
    [_netManager cancelParty:self.party];
}

- (void)interfaceReturnDataSuccess:(id)jsonDic with:(int)interfaceType {
    switch (interfaceType) {
        case kGetPartyRelationship: {
            //进入 读取关系与详情
            if (jsonDic) {
                _relArray = [Model_User objectArrayWithKeyValuesArray:[jsonDic objectForKey:@"relation"]];
                self.party = [[Model_Party objectArrayWithKeyValuesArray:[jsonDic objectForKey:@"party"]] objectAtIndex:0];
                [self reloadPeopleNum];
            }
        }
            break;
        case kUpdateSchedule: {
            if (jsonDic) {
                //更新上级聚会数组的关系状态
                self.party.relationship = _relation.relationship;
                [self setParticipateStatus];
                for (Model_User *user in _relArray) {
                    if ([user.pk_user isEqualToNumber:[Model_User loadFromUserDefaults].pk_user]) {
                        user.relationship = _relation.relationship;
                    }
                }
                [self reloadPeopleNum];
                [self.delegate DetailChange:self.party];
            }
        }
            break;
            
        case kCreateRelationForParty: {
            if (jsonDic) {
                _relation.pk_party_user = (NSNumber *)jsonDic;
                self.party.relationship = @0;
                [self reloadPeopleNum];
                [self.delegate DetailChange:self.party];
            }
        }
            break;
            
        case kCancelParty: {
            if (jsonDic) {
                //聚会取消成功
                [self.navigationController popViewControllerAnimated:YES];
                [self.delegate cancelParty:self.party];
            }
        }
        default:
            break;
    }
    [SVProgressHUD dismiss];
}

- (void)interfaceReturnDataError:(int)interfaceType {
    [SVProgressHUD showErrorWithStatus:@"网络错误"];
}

- (IBAction)tapBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"MapView"]) {
        //进入地图
        PartyMapViewController *childController = (PartyMapViewController *)segue.destinationViewController;
        childController.party = self.party;
    } else {
        UIButton *pressedButton = (UIButton *)sender;
        PartyPeopleListViewController *childController = (PartyPeopleListViewController *)[segue destinationViewController];
        childController.showStatus = (int)pressedButton.tag;
        childController.relationArray = _relArray;
    }

}


@end
