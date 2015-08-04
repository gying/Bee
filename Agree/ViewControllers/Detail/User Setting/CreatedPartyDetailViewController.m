//
//  CreatedPartyDetailViewController.m
//  Agree
//
//  Created by Agree on 15/7/17.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "CreatedPartyDetailViewController.h"

#import "SRNet_Manager.h"
#import "Model_Party_User.h"
#import <SVProgressHUD.h>
#import "MJExtension.h"
#import "PartyPeopleListViewController.h"
#import "PartyMapViewController.h"

#import "PrepayViewController.h"


#import <BaiduMapAPI/BMapKit.h>
#import "Model_Party.h"
#import "SRTool.h"

#define AgreeBlue [UIColor colorWithRed:82/255.0 green:213/255.0 blue:204/255.0 alpha:1.0]

@interface CreatedPartyDetailViewController ()<UIActionSheetDelegate,BMKLocationServiceDelegate,BMKMapViewDelegate, PerpayDelegate> {
    Model_Party_User *_relation;
    NSMutableArray *_relArray;
    int _showStatus;
    BMKMapView *_bdMapView;
    UIButton * customButton;
}

@end

@implementation CreatedPartyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.party.longitude && self.party.latitude) {
        //如果存在经纬度数据
        //则开始更新地区信息
        _bdMapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width - 16, [[UIScreen mainScreen] bounds].size.height - 410)];
        
        self.mapConHeight.constant = CGRectGetHeight(_bdMapView.bounds);
        //        [self.locationMapView addSubview:_bdMapView];
        [self.locationMapView insertSubview:_bdMapView atIndex:0];
        [_bdMapView setDelegate:self];
        
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
    
    
    //类型的边框与圆弧
    self.payType.layer.cornerRadius = self.payType.frame.size.height/4;
    //    self.payType.layer.borderColor = AgreeBlue.CGColor;
    self.payType.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
    self.payType.layer.borderWidth = 1.0;
    self.payType.textColor = AgreeBlue;
    self.payType.alpha = 0.7;

    
    switch (self.party.pay_type.intValue) {
        case 1: {
            //请客
            [self.payType setText:@"请客"];
            [self.cheakButton setHidden:YES];
        }
            
            break;
        case 2: {
            //AA
            [self.payType setText:@"AA制"];
            if (self.party.pay_amount) {
                //已经结账的AA制聚会
                if ([SRTool partyPayorIsSelf:self.party]) {
                    //聚会的付款人为本人
                    [self.cheakButton setHidden:YES];
                    [self.payDoneView setHidden:NO];
                    
                    self.moneyAmount.text = [NSString stringWithFormat:@"总额 %d", self.party.pay_amount.intValue];
                    self.moneyDone.text = @"已收 正在计算...";
                } else {
                    switch (self.party.user_pay_type.intValue) {
                        case 1: {
                            //未支付
                        }
                            break;
                        case 2: {
                            //已支付
                            //已支付 - 显示付款的详情内容
                            [self.cheakButton setHidden:YES];
                            [self.payDoneView setHidden:NO];
                            
                            self.moneyAmount.text = [NSString stringWithFormat:@"总额 %d", self.party.pay_amount.intValue];
                            self.moneyDone.text = @"已收 正在计算...";
                            
                        }
                            break;
                        case 3: {
                            //支持代付
                        }
                            break;
                        default: {
                            //默认为空为未付
                        }
                            break;
                    }
                }
            } else {
                
            }
        }
            
            break;
        case 3: {
            //预付
            [self.payType setText:@"预付款"];
            [self.cheakButton setHidden:YES];
            
            [self.payDoneView setHidden:NO];
            
            self.moneyAmount.text = @"参与人数";
            self.moneyDone.text = @"付款人数";
            
        }
            
            break;
        default: {
            [self.payType setText:@"未指定"];
            [self.cheakButton setHidden:YES];
        }
            break;
    }
    
    
    //判断是否是创建者本身.
    if ([[Model_User loadFromUserDefaults].pk_user isEqualToNumber:self.party.fk_user]) {
        [self.cancelButton setHidden:NO];
    } else {
        [self.cancelButton setHidden:NO];
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
    
    [self.cheakButton.layer setCornerRadius:self.cheakButton.frame.size.height/2];
    [self.cheakButton.layer setMasksToBounds:YES];
    self.cheakButton.backgroundColor = AgreeBlue;
    [self.cheakButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
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
                                    //进入 读取关系与详情
                                    if (jsonDic) {
                                        _relArray = (NSMutableArray *)[Model_User objectArrayWithKeyValuesArray:[jsonDic objectForKey:@"relation"]];
                                        self.party = [[Model_Party objectArrayWithKeyValuesArray:[jsonDic objectForKey:@"party"]] objectAtIndex:0];
                                        [self reloadPeopleNum];
                                    }
                                } failure:^(NSError *error, NSURLSessionDataTask *task) {
                                    
                                }];
    }
    
    [self setParticipateStatus];
    
    if (0 == self.party.inNum.intValue) {
        //无人参与聚会
        [self.payDoneView setHidden:YES];
        [self.cheakButton setHidden:YES];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)reloadPeopleNum {
    
    int inNum = 0;
    int outNum = 0;
    int unNum = 0;
    
    int moneyDoneSum = 0;
    //付款人数
    int payNum = 0;
    
    for (Model_User *user in _relArray) {
        //这里顺便对已付的款项进行计算
        
        if (user.pay_type && 1 != user.pay_type.intValue && 0 != user.pay_type.intValue) {
            moneyDoneSum = moneyDoneSum + user.pay_amount.intValue;
            payNum++;
        }
        
        
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
    
    switch (self.party.pay_type.intValue) {
        case 1: {
            //请客
            
        }
            
            break;
        case 2: {
            //AA
            //这里获取到已付款的数量,并做展示
            self.moneyDone.text = [NSString stringWithFormat:@"已收 %d", moneyDoneSum];
        }
            
            break;
        case 3: {
            //预付
            self.moneyDone.text = [NSString stringWithFormat:@"已付人数 %d", payNum];
            self.moneyAmount.text = [NSString stringWithFormat:@"参与人数 %d", inNum];
            
        }
            
            break;
        default: {
            
        }
            break;
    }
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
    
    if ([SRTool partyCreatorIsSelf:self.party]) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择操作类型"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                             destructiveButtonTitle:@"取消聚会"
                                                  otherButtonTitles:@"分享",@"添加到系统日历",nil];
        [sheet showInView:self.view];
    }else
    {
        UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"选择操作类型" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享",@"添加到系统日历", nil];
        [sheet showInView:self.view];
    }
    
}

- (IBAction)tapBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([SRTool partyCreatorIsSelf:self.party]) {
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

    }else
    {
        
        switch (buttonIndex) {
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
            
        default:
            break;
    }
}


- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {
    BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    
    [newAnnotationView setFrame:CGRectMake(newAnnotationView.frame.origin.x, newAnnotationView.frame.origin.y,35,35)];
    
    [newAnnotationView setEnabled:YES];
    [newAnnotationView setContentMode:UIViewContentModeScaleAspectFit];
    customButton = [[UIButton alloc]initWithFrame:CGRectMake(-6.55,-3,45,45)];
    customButton.backgroundColor = [UIColor clearColor];
//    [customButton addTarget:self action:@selector(daohang) forControlEvents:UIControlEventTouchUpInside];
    [customButton setImage:[UIImage imageNamed:@"sr_map_point"] forState:UIControlStateNormal];
    //    BMKActionPaopaoView * paopaoView = [[BMKActionPaopaoView alloc]initWithCustomView:customButton];
    //    newAnnotationView.paopaoView = paopaoView;
    newAnnotationView.backgroundColor = [UIColor clearColor];
    [newAnnotationView addSubview:customButton];
    return newAnnotationView;
}


- (IBAction)CheakButton:(id)sender {
    NSLog(@"结账");
}

- (void)inputAmount:(NSNumber *)amount {
    self.party.pay_amount = amount;
    //只发送修改的关键部分
    Model_Party *sendParty = [[Model_Party alloc] init];
    sendParty.pk_party = self.party.pk_party;
    sendParty.pay_amount = amount;
    sendParty.pay_fk_user = [Model_User loadFromUserDefaults].pk_user;
    //输入结账完成,这里将做结账处理
    [SRNet_Manager requestNetWithDic:[SRNet_Manager settleParty:sendParty] complete:^(NSString *msgString, id jsonDic, int interType, NSURLSessionDataTask *task) {
        //返回结账信息成功.
        
    } failure:^(NSError *error, NSURLSessionDataTask *task) {
        //结账信息输入失败.
        
    }];
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"MapView"]) {
        //进入地图
        PartyMapViewController * childController = (PartyMapViewController *)segue.destinationViewController;
        childController.party = self.party;
    } else if([segue.identifier isEqualToString:@"PREPAY"]){
        PrepayViewController * childController = (PrepayViewController *)segue.destinationViewController;
        [childController setDelegate:self];
//       [childController.payTextField becomeFirstResponder];
    }else{
        UIButton *pressedButton = (UIButton *)sender;
        PartyPeopleListViewController *childController = (PartyPeopleListViewController *)[segue destinationViewController];
        childController.party = self.party;
        childController.isCreator = [SRTool partyCreatorIsSelf:self.party];
        childController.isPayor = [SRTool partyPayorIsSelf:self.party];
        childController.showStatus = (int)pressedButton.tag;
        childController.relationArray = _relArray;
    }
}

@end
