//
//  HistoryPartyDetailViewController.m
//  Agree
//
//  Created by Agree on 15/7/20.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "HistoryPartyDetailViewController.h"

#import "SRNet_Manager.h"
#import "Model_Party_User.h"
#import <SVProgressHUD.h>
#import "MJExtension.h"
#import "PartyPeopleListViewController.h"
#import "PartyMapViewController.h"

#import "BMapKit.h"

#import "Model_Party.h"
#import "SRTool.h"

#define AgreeBlue [UIColor colorWithRed:82/255.0 green:213/255.0 blue:204/255.0 alpha:1.0]

@interface HistoryPartyDetailViewController ()<SRNetManagerDelegate, UIActionSheetDelegate> {
    SRNet_Manager *_netManager;
    Model_Party_User *_relation;
    NSMutableArray *_relArray;
    int _showStatus;
    BMKMapView *_bdMapView;
    
    UIActionSheet * canelActionSheet;
    UIActionSheet * payActionSheet;
    
}

@end

@implementation HistoryPartyDetailViewController

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
    
    [self.payButton.layer setCornerRadius:self.payButton.frame.size.height/2];
    [self.payButton.layer setMasksToBounds:YES];
    self.payButton.backgroundColor = AgreeBlue;
    [self.payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.addressLabel setText:self.party.location];
    
    
    NSDate *beginDate = self.party.begin_time;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy年M月d日 EEEE aa hh:mm"];
    [self.beginDateLabel setText:[dateFormatter stringFromDate:beginDate]];
    
    Model_Party *sendParty = [[Model_Party alloc] init];
    sendParty.pk_party = self.party.pk_party;
    
    //    if (self.party) {
    //        [_netManager getPartyRelationship:sendParty];
    //    }
    //
    //    if (nil == self.party.relationship) {
    //        //在与聚会未产生关系时(第一次进入聚会详情),建立与聚会关系
    //        _relation.relationship = @0;
    //
    //        if ([self.party.fk_user isEqualToNumber:[Model_User loadFromUserDefaults].pk_user]) {
    //            _relation.type = @2;
    //        } else {
    //            _relation.type = @1;
    //        }
    //
    //        [_netManager createRelationshipForParty:_relation];
    //    }
    
    if (self.party) {
        [_netManager getPartyRelationship:sendParty];
    }
    
    [self setParticipateStatus];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    //    NSLog(@"%@",self.inNumLabel.text);
    self.outNumLabel.text = [NSString stringWithFormat:@"%d", outNum];
    //    NSLog(@"%@",self.outNumLabel.text);
    self.unkownLabel.text = [NSString stringWithFormat:@"%d", unNum];
    //    NSLog(@"%@",self.unkownLabel.text);
}

- (void)setParticipateStatus {
    switch ([_relation.relationship intValue]) {
        case 0: {
            //未选择
            
        }
            break;
        case 1: {
            //同意
            
        }
            break;
        case 2: {
            //拒绝
            
        }
            break;
        default:
            break;
    }
}

- (IBAction)pressedTheCanelButton:(id)sender {
    canelActionSheet = [[UIActionSheet alloc] initWithTitle:@"选择操作类型"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:@"取消聚会"
                                              otherButtonTitles:@"分享",@"添加到系统日历",nil];
    [canelActionSheet showInView:self.view];
}

#pragma mark - 网络代理

- (void)interfaceReturnDataSuccess:(id)jsonDic with:(int)interfaceType {
    switch (interfaceType) {
        case kGetPartyRelationship: {
            //进入 读取关系与详情
            if (jsonDic) {
                _relArray = (NSMutableArray *)[Model_User objectArrayWithKeyValuesArray:[jsonDic objectForKey:@"relation"]];
                self.party = [[Model_Party objectArrayWithKeyValuesArray:[jsonDic objectForKey:@"party"]] objectAtIndex:0];
                [self reloadPeopleNum];
            }
        }
            break;
        case kUpdateSchedule: {
            if (jsonDic) {
                [SVProgressHUD showSuccessWithStatus:@"参与信息发送成功"];
                
                //更新上级聚会数组的关系状态
                self.party.relationship = _relation.relationship;
                [self setParticipateStatus];
                BOOL userInAry = NO;
                
                for (Model_User *user in _relArray) {
                    if ([user.pk_user isEqualToNumber:[Model_User loadFromUserDefaults].pk_user]) {
                        user.relationship = _relation.relationship;
                        userInAry = YES;
                    }
                }
                
                if (!userInAry) {
                    //用户并不在数组中,是初次加入的关系
                    Model_User *newUser = [Model_User loadFromUserDefaults];
                    newUser.relationship = _relation.relationship;
                    [_relArray addObject:newUser];
                }
                [self reloadPeopleNum];
                [self.delegate detailChange:self.party];
                
                [SRTool addPartyUpdateTip:1];
            }
        }
            break;
            
        case kCreateRelationForParty: {
            if (jsonDic) {
                _relation.pk_party_user = (NSNumber *)jsonDic;
                self.party.relationship = @0;
                [self reloadPeopleNum];
                [self.delegate detailChange:self.party];
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
            break;
        case kShareParty: {
            if (jsonDic) {
                //聚会分享获取链接成功
                //将聚会链接赋值到粘贴板
                UIPasteboard *pboard = [UIPasteboard generalPasteboard];
                pboard.string = (NSString *)jsonDic;
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:@"聚会链接已复制到您的粘贴板"
                                                                   delegate:self
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                alertView.tag = 2;
                [alertView show];
            }
        }
            break;
        default:
            break;
    }
}

- (void)interfaceReturnDataError:(int)interfaceType {
    [SVProgressHUD showErrorWithStatus:@"网络错误"];
}

- (IBAction)tapBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {

        case 0:
            if (actionSheet == canelActionSheet) {
                //取消聚会
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:@"确定要取消该聚会吗?"
                                                                   delegate:self
                                                          cancelButtonTitle:@"取消"
                                                          otherButtonTitles:@"确定", nil];
                alertView.tag = 1;
                [alertView show];

            }else if(actionSheet == payActionSheet)
            {
                NSLog(@"付款类型0");
            }
            

            break;
        case 1:
            
            if (actionSheet == canelActionSheet) {
                //分享聚会
                if (!_netManager) {
                    _netManager = [[SRNet_Manager alloc] initWithDelegate:self];
                }
                [_netManager shareParty:self.party];
            }else if(actionSheet == payActionSheet)
            {
                NSLog(@"付款类型1");
            }
            break;
            
#pragma mark -- 将日程添加到系统日历
        case 2:
            
            if (actionSheet == canelActionSheet) {
                //添加到日程
                NSLog(@"添加到日程");
                //事件市场
                EKEventStore *eventStore = [[EKEventStore alloc] init];
                
                //6.0及以上通过下面方式写入事件
                if ([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)])
                {
                    // the selector is available, so we must be on iOS 6 or newer
                    [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (error)
                            {
                                //错误信息
                                // display error message here
                            }
                            else if (!granted)
                            {
                                //被用户拒绝，不允许访问日历
                                // display access denied error message here
                            }
                            else
                            {
                                // access granted
                                // ***** do the important stuff here *****
                                
                                //事件保存到日历
                                
                                
                                //创建事件
                                EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
                                event.title     = self.party.name;
                                event.location = self.party.location;
                                
                                NSDateFormatter *tempFormatter = [[NSDateFormatter alloc]init];
                                
                                [tempFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
                                
                                event.allDay = NO;
                                
                                NSDate * startTime = _party.begin_time;
                                NSDate * endTime = [NSDate dateWithTimeInterval:3600 sinceDate:startTime];
                                
                                event.startDate = startTime;
                                event.endDate = endTime;
                                
                                //在事件前多少秒开始提醒
                                //提前一个小时提醒
                                [event addAlarm:[EKAlarm alarmWithRelativeOffset:-60.0 * 60.0]];
                                
                                
                                [event setCalendar:[eventStore defaultCalendarForNewEvents]];
                                NSError *err;
                                [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
                                
                                
                                if (err) {
                                    
                                }
                                UIAlertView *alert = [[UIAlertView alloc]
                                                      initWithTitle:@"添加成功"
                                                      message:@" "
                                                      delegate:nil
                                                      cancelButtonTitle:@"完成"
                                                      otherButtonTitles:nil];
                                [alert show];
                            }
                        });
                    }];
                }
            }else if(actionSheet == payActionSheet)
            {
                NSLog(@"付款类型2");
            }

            break;
        default:
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (alertView.tag) {
        case 1: {
            //取消聚会
            switch (buttonIndex) {
                case 0: {   //取消
                }
                    break;
                case 1: {   //确定
                    //取消聚会
                    [_netManager cancelParty:self.party];
                }
                    break;
                default:
                    break;
            }
        }
            break;
            
        case 2: {
            //分享聚会
        }
            break;
            
        default:
            break;
    }
}

- (IBAction)CheakButton:(id)sender {
    
    NSLog(@"付款");
    payActionSheet = [[UIActionSheet alloc]initWithTitle:@"选择付款类型" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"类型0",@"类型1",@"类型2", nil];
    
    
    [payActionSheet showInView:self.view];
}



#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//    if ([segue.identifier isEqualToString:@"MapView"]) {
//        //进入地图
//        PartyMapViewController *childController = (PartyMapViewController *)segue.destinationViewController;
//        childController.party = self.party;
//    } else {
//        UIButton *pressedButton = (UIButton *)sender;
//        PartyPeopleListViewController *childController = (PartyPeopleListViewController *)[segue destinationViewController];
//        childController.showStatus = (int)pressedButton.tag;
//        childController.relationArray = _relArray;
//    }
//    
//}

@end
