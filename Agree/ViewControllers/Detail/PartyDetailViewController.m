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
#import "PartyPeopleListViewController.h"
#import "PartyMapViewController.h"
#import "AllPartyTableViewCell.h"
#import "PeopleListTableViewCell.h"
#import "BMapKit.h"

#import "Model_Party.h"
#import "SRTool.h"

#define AgreeBlue [UIColor colorWithRed:82/255.0 green:213/255.0 blue:204/255.0 alpha:1.0]

@interface PartyDetailViewController () <UIActionSheetDelegate> {
    Model_Party_User *_relation;
    NSMutableArray *_relArray;
    int _showStatus;
    BMKMapView *_bdMapView;
}

@end

@implementation PartyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.navigationItem setTitle:self.party.name];
    
    //进来先判断有没有参与关系
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
    }\
    
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
        [SRNet_Manager requestNetWithDic:[SRNet_Manager getPartyRelationshipDic:sendParty]
                                complete:^(NSString *msgString, id jsonDic, int interType, NSURLSessionDataTask *task) {
                                    if (jsonDic) {
                                        _relArray = (NSMutableArray *)[Model_User objectArrayWithKeyValuesArray:[jsonDic objectForKey:@"relation"]];
                                        self.party = [[Model_Party objectArrayWithKeyValuesArray:[jsonDic objectForKey:@"party"]] objectAtIndex:0];
                                        [self reloadPeopleNum];
                                    }
                                } failure:^(NSError *error, NSURLSessionDataTask *task) {
                                    
                                }];
        
    }
    
    if (nil == self.party.relationship) {
        //在与聚会未产生关系时(第一次进入聚会详情),建立与聚会关系
        _relation.relationship = @0;
        
        if ([self.party.fk_user isEqualToNumber:[Model_User loadFromUserDefaults].pk_user]) {
            _relation.type = @2;
        } else {
            _relation.type = @1;
        }
        [SRNet_Manager requestNetWithDic:[SRNet_Manager createRelationshipForPartyDic:_relation]
                                complete:^(NSString *msgString, id jsonDic, int interType, NSURLSessionDataTask *task) {
                                    if (jsonDic) {
                                        _relation.pk_party_user = (NSNumber *)jsonDic;
                                        self.party.relationship = @0;
                                        [self reloadPeopleNum];
                                        [self.delegate detailChange:self.party];
                                    }
                                } failure:^(NSError *error, NSURLSessionDataTask *task) {
                                    
                                }];

    } else if ([@3 isEqual:self.party.pay_type]) {
        if ((nil != self.party.relationship) && ([@1  isEqual: self.party.relationship])) {
            self.yesButton.enabled = NO;
            self.noButton.enabled = NO;

        }
    }
    
    [self setParticipateStatus];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pressedYesButton:(id)sender {

    if ([@3 isEqual: self.party.pay_type]) {
        NSLog(@"弹出AlertView");
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"确定要参加聚会吗" message:@"确定后不能取消" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 3;
        [alertView show];
    } else {
        if (1 == [_relation.relationship intValue]) {
            //取消选中状态
            
            _relation.relationship = @0;
            self.party.inNum = [NSNumber numberWithInt:[self.party.inNum intValue] - 1];
            [SVProgressHUD showWithStatus:@"正在取消参与请求"];
        } else {
            _relation.relationship = @1;
            self.party.inNum = [NSNumber numberWithInt:[self.party.inNum intValue] + 1];
            [SVProgressHUD showWithStatus:@"正在确认参与请求"];
        }

        [SRNet_Manager requestNetWithDic:[SRNet_Manager updateScheduleDic:_relation]
                                complete:^(NSString *msgString, id jsonDic, int interType, NSURLSessionDataTask *task) {
                                    if (jsonDic) {
                                        [self updateScheduleDicDone:jsonDic];
                                    }
                                } failure:^(NSError *error, NSURLSessionDataTask *task) {
                                    
                                }];
    }
}

- (IBAction)pressedNoButton:(id)sender {
    if (2 == [_relation.relationship intValue]) {
        //取消选中状态
        _relation.relationship = @0;
        [SVProgressHUD showWithStatus:@"正在取消拒绝请求"];
    } else {
        
        if (1 == _relation.relationship.intValue ) {
            self.party.inNum = [NSNumber numberWithInt:[self.party.inNum intValue] - 1];
        }
        _relation.relationship = @2;
        [SVProgressHUD showWithStatus:@"正在确认拒绝请求"];
    }
    [SRNet_Manager requestNetWithDic:[SRNet_Manager updateScheduleDic:_relation]
                            complete:^(NSString *msgString, id jsonDic, int interType, NSURLSessionDataTask *task) {
                                if (jsonDic) {
                                    [self updateScheduleDicDone:jsonDic];
                                }
                            } failure:^(NSError *error, NSURLSessionDataTask *task) {
                                
                            }];
}

- (void)updateScheduleDicDone: (id)jsonDic {
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
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择操作类型"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:@"取消聚会"
                                              otherButtonTitles:@"分享",@"添加到系统日历",nil];
    [sheet showInView:self.view];
}


- (IBAction)tapBackButton:(id)sender {
       [self.navigationController popViewControllerAnimated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: {
            //取消聚会
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"确定要取消该聚会吗?"
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"确定", nil];
            alertView.tag = 1;
            [alertView show];
        }
            break;
        case 1: {
            //分享聚会
            [SRNet_Manager requestNetWithDic:[SRNet_Manager sharePartyDic:self.party]
                                    complete:^(NSString *msgString, id jsonDic, int interType, NSURLSessionDataTask *task) {
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
                                    } failure:^(NSError *error, NSURLSessionDataTask *task) {
                                        
                                    }];
        }
            break;
            
        case 2: {
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
                    [SRNet_Manager requestNetWithDic:[SRNet_Manager cancelPartyDic:self.party]
                                            complete:^(NSString *msgString, id jsonDic, int interType, NSURLSessionDataTask *task) {
                                                if (jsonDic) {
                                                    //聚会取消成功
                                                    [self.navigationController popViewControllerAnimated:YES];
                                                    [self.delegate cancelParty:self.party];
                                                }
                                            } failure:^(NSError *error, NSURLSessionDataTask *task) {
                                                
                                            }];
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
        case 3:
        {
            switch (buttonIndex) {
                case 0:{
                    //取消
                }
                    break;
                    
                case 1:{
                    //确定参加聚会
                    NSLog(@"确定参加聚会");
                    if (1 == [_relation.relationship intValue]) {
                        //取消选中状态
                        
                        _relation.relationship = @0;
                        self.party.inNum = [NSNumber numberWithInt:[self.party.inNum intValue] - 1];
                        [SVProgressHUD showWithStatus:@"正在取消参与请求"];
                    } else {
                        _relation.relationship = @1;
                        self.party.inNum = [NSNumber numberWithInt:[self.party.inNum intValue] + 1];
                        [SVProgressHUD showWithStatus:@"正在确认参与请求"];
                    }
                    [SRNet_Manager requestNetWithDic:[SRNet_Manager updateScheduleDic:_relation]
                                            complete:^(NSString *msgString, id jsonDic, int interType, NSURLSessionDataTask *task) {
                                                if (jsonDic) {
                                                    [self updateScheduleDicDone:jsonDic];
                                                }
                                            } failure:^(NSError *error, NSURLSessionDataTask *task) {
                                                
                                            }];
                    
                    self.yesButton.enabled = NO;
                    self.noButton.enabled = NO;
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
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
    } else if([segue.identifier isEqualToString:@"INBUTTON"])
    {
        NSLog(@"进入参与界面");
        
        UIButton *pressedButton = (UIButton *)sender;
        PartyPeopleListViewController *childController = (PartyPeopleListViewController *)[segue destinationViewController];
        childController.showStatus = (int)pressedButton.tag;
        childController.relationArray = _relArray;
    }else if ([segue.identifier isEqualToString:@"OUTBUTTON"])
    {
        NSLog(@"进入拒绝界面");
        UIButton *pressedButton = (UIButton *)sender;
        PartyPeopleListViewController *childController = (PartyPeopleListViewController *)[segue destinationViewController];
        childController.showStatus = (int)pressedButton.tag;
        childController.relationArray = _relArray;

        
    }else if([segue.identifier isEqualToString:@"UNKNOWBUTTON"])
    {
        NSLog(@"进入不确定界面");
        UIButton *pressedButton = (UIButton *)sender;
        PartyPeopleListViewController *childController = (PartyPeopleListViewController *)[segue destinationViewController];
        childController.showStatus = (int)pressedButton.tag;
        childController.relationArray = _relArray;

    }else
    {

    }
}


@end
