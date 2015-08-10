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

#import "PrepayViewController.h"

#import <BaiduMapAPI/BMapKit.h>

#import "Model_Party.h"
#import "SRTool.h"

#import <JGActionSheet.h>



#define AgreeBlue [UIColor colorWithRed:82/255.0 green:213/255.0 blue:204/255.0 alpha:1.0]

@interface PartyDetailViewController () <BMKLocationServiceDelegate,BMKMapViewDelegate, SRPayDelegate> {
    Model_Party_User *_relation;
    NSMutableArray *_relArray;
    int _showStatus;
    BMKMapView *_bdMapView;
    
    UIButton * customButton;
    
    JGActionSheet *_sheet;
}

@end

@implementation PartyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.navigationItem setTitle:self.party.name];
    
    [self.payButton setHidden:YES];
    
    //类型的边框与圆弧
    self.payType.layer.cornerRadius = self.payType.frame.size.height/4;
//    self.payType.layer.borderColor = AgreeBlue.CGColor;
    self.payType.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
    self.payType.layer.borderWidth = 1.0;
    self.payType.textColor = AgreeBlue;
    self.payType.alpha = 0.7;
    
    [self.money setText:[NSString stringWithFormat:@"¥%@", self.party.pay_amount]];
    
    

    if ([@1 isEqual:self.party.relationship]) {
        [self.money setTextColor:[UIColor whiteColor]];
        [self.inLabel setTextColor:[UIColor whiteColor]];
    } else {
        [self.money setTextColor:[UIColor lightGrayColor]];
        [self.inLabel setTextColor:[UIColor lightGrayColor]];
    }
    
    if (![@3  isEqual: self.party.pay_type]) {
        self.money.hidden = YES;
        self.inLabel.hidden = YES;
        [self.yesButton setTitle:@"参与" forState:UIControlStateNormal];
    }
    
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
    
    [self.payButton.layer setCornerRadius:self.payButton.frame.size.height/2];
    [self.payButton.layer setMasksToBounds:YES];
    
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
        //设置加入时候为未支付状态
        _relation.pay_type = @0;
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
                                        [self.delegate detailChange:self.party with:self.intoType];
                                    }
                                } failure:^(NSError *error, NSURLSessionDataTask *task) {
                                    
                                }];

    }
    
    if (2 == self.intoType) {
        //如果为历史聚会,聚会的参与情况将不能变动,则将参与的按钮全部隐藏处理
        [self.yesButton setHidden:YES];
        [self.noButton setHidden:YES];
    }
    
    
    switch (self.party.pay_type.intValue) {
        case 1: {
            //请客
            [self.payType setText:@"请客"];
            
            
        }
            break;
        case 2: {
            //AA
            [self.payType setText:@"AA制"];
            //AA制只有进入历史聚会了之后才让结账
            if (2 == self.intoType) {
                //历史聚会
                if (self.party.pay_amount) {
                    //如果历史聚会已经结账完成,开始判断个人是否支付
                    [self.payButton setTitle:@"支付" forState:UIControlStateNormal];
                    [self.payButton setHidden:NO];
                    
                    //首先判断支付者是否为本人
                    if ([SRTool partyPayorIsSelf:self.party]) {
                        //聚会的付款人为本人
                        [self.payButton setHidden:YES];
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
                                [self.payButton setHidden:YES];
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
                    //如果历史聚会还为结账,则出现结账按钮
                    [self.payButton setTitle:@"结账" forState:UIControlStateNormal];
                    [self.payButton setHidden:NO];
                }
            }
        }
            break;
            
        case 3: {
            //预付
            [self.payType setText:@"预付款"];
            if (2 == self.intoType) {
                //历史聚会
                
            } else {
                //日程中
                //预付款聚会如果已经参与,则变为支付按钮 或者 参与人数提示
                //这里为预付款聚会 & 已经参与
                if ((nil != self.party.relationship) && ([@1  isEqual: self.party.relationship])) {
                    //用户的标识为参与
                    //这里为预付款聚会已参与
                    self.yesButton.hidden = YES;
                    self.noButton.hidden = YES;
                    
                    if ([SRTool partyPayorIsSelf:self.party]) {
                        //查看聚会的付款人是否为自己
                        //如果自己为付款人则显示人数数据
                        [self.payDoneView setHidden:NO];
                        
                        self.moneyAmount.text = @"参与人数";
                        self.moneyDone.text = @"付款人数";
                    } else {
                        //如果付款者并非自己,则开始分析支付情况
                        switch (self.party.user_pay_type.intValue) {
                            case 0: {
                                //未支付
                                [self.payDoneView setHidden:YES];
                                self.payButton.hidden = NO;
                            }
                                break;
                            case 2: {
                                //已支付
                                //已支付 - 显示付款的详情内容
                                [self.payButton setHidden:YES];
                                [self.payDoneView setHidden:NO];
                                
                                self.moneyAmount.text = @"参与人数";
                                self.moneyDone.text = @"付款人数";
                            }
                                break;
                            case 3: {
                                //支持代付
                            }
                                break;
                            default: {
                                //默认为空为未付
                                [self.payDoneView setHidden:YES];
                                self.payButton.hidden = NO;
                            }
                                break;
                        }
                    }
                }
            }
        }
            
            break;
        default: {
            [self.payType setText:@"未指定"];
        }
            break;
    }
    
    
    
    
    [self setParticipateStatus];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pressedYesButton:(id)sender {
    if ([@3 isEqual: self.party.pay_type]) {
        [SRTool showSRAlertViewWithTitle:@"确定要参加?" message:@"该聚会为预付款聚会,\n参加了就不能取消了哦~" cancelButtonTitle:@"我再想想" otherButtonTitle:@"确定!" tapCancelButtonHandle:^(NSString *msgString) {
            
        } tapOtherButtonHandle:^(NSString *msgString) {
            //确定参加聚会
            if (1 == [_relation.relationship intValue]) {
                //取消选中状态
                _relation.relationship = @0;
                self.party.inNum = [NSNumber numberWithInt:[self.party.inNum intValue] - 1];
                [SVProgressHUD showWithStatus:@"正在取消参与请求"];
                
                [self.money setTextColor:[UIColor lightGrayColor]];
                [self.inLabel setTextColor:[UIColor lightGrayColor]];
                
            } else {
                _relation.relationship = @1;
                self.party.inNum = [NSNumber numberWithInt:[self.party.inNum intValue] + 1];
                [SVProgressHUD showWithStatus:@"正在确认参与请求"];
                
                [self.money setTextColor:[UIColor whiteColor]];
                [self.inLabel setTextColor:[UIColor whiteColor]];
                //将聚会关系的状态设置为2 以便服务端识别为预付款聚会
                _relation.pay_amount = self.party.pay_amount;
                
                _relation.pay_type = @0;
                
                //这里因为版本兼容关系,如果预付聚会没有收款人,则将收款人设置为创建者.
                if (self.party.pay_fk_user) {
                    _relation.pay_fk_user = self.party.pay_fk_user;
                } else {
                    _relation.pay_fk_user = self.party.fk_user;
                }
                
                _relation.pay_fk_user = self.party.pay_fk_user;
                _relation.status = @2;
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
        }];
        
    } else {
        if (1 == [_relation.relationship intValue]) {
            //取消选中状态
            
            _relation.relationship = @0;
            self.party.inNum = [NSNumber numberWithInt:[self.party.inNum intValue] - 1];
            [SVProgressHUD showWithStatus:@"正在取消参与请求"];
            [self.money setTextColor:[UIColor lightGrayColor]];
            [self.inLabel setTextColor:[UIColor lightGrayColor]];
            
        } else {
            _relation.relationship = @1;
            self.party.inNum = [NSNumber numberWithInt:[self.party.inNum intValue] + 1];
            [SVProgressHUD showWithStatus:@"正在确认参与请求"];
            [self.money setTextColor:[UIColor whiteColor]];
            [self.inLabel setTextColor:[UIColor whiteColor]];
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
        [self.money setTextColor:[UIColor lightGrayColor]];
        [self.inLabel setTextColor:[UIColor lightGrayColor]];
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
    
    [self.money setTextColor:[UIColor lightGrayColor]];
    [self.inLabel setTextColor:[UIColor lightGrayColor]];
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
    [self.delegate detailChange:self.party with:self.intoType];
    
    [SRTool addPartyUpdateTip:1];
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
    if (!_sheet) {
        //如果是创建者
        if ([[Model_User loadFromUserDefaults].pk_user isEqualToNumber:self.party.fk_user]) {
            _sheet = [SRTool showSRSheetInView:self.view
                                     withTitle:@"提示"
                                       message:@"选择想要对聚会做的操作类型"
                               withButtonArray:@[@"取消聚会", @"分享聚会", @"添加到系统日历"]
                               tapButtonHandle:^(int buttonIndex) {
                                   switch (buttonIndex) {
                                       case 0: {
                                           //取消聚会
                                           [self cancelParty];
                                       }
                                           break;
                                       case 1: {
                                           //分享聚会
                                           [self shareParty];
                                       }
                                           break;
                                       case 2: {
                                           //添加到日程
                                           [self addToEvent];
                                           
                                       }
                                           break;
                                       default:
                                           break;
                                   }
                                   _sheet = nil;
                               } tapCancelHandle:^{
                                   _sheet = nil;
                               }];
            
        } else {
            _sheet = [SRTool showSRSheetInView:self.view
                                     withTitle:@"提示"
                                       message:@"选择想要对聚会做的操作类型"
                               withButtonArray:@[@"分享聚会", @"添加到系统日历"]
                               tapButtonHandle:^(int buttonIndex) {
                                   switch (buttonIndex) {
                                       case 0: {
                                           //分享聚会
                                           [self shareParty];
                                       }
                                           break;
                                       case 1: {
                                           //添加到日程
                                           [self addToEvent];
                                           
                                       }
                                           break;
                                       default:
                                           break;
                                   }
                                   _sheet = nil;
                               } tapCancelHandle:^{
                                   _sheet = nil;
                               }];
        }
    } else {
        [_sheet dismissAnimated:YES];
        _sheet = nil;
    }
}

- (void)cancelParty {
    [SRTool showSRAlertViewWithTitle:@"提示" message:@"确定要取消聚会吗?" cancelButtonTitle:@"我再想想" otherButtonTitle:@"确定!"
               tapCancelButtonHandle:^(NSString *msgString) {
                   
               } tapOtherButtonHandle:^(NSString *msgString) {
                   [SRNet_Manager requestNetWithDic:[SRNet_Manager cancelPartyDic:self.party]
                                           complete:^(NSString *msgString, id jsonDic, int interType, NSURLSessionDataTask *task) {
                                               if (jsonDic) {
                                                   //聚会取消成功
                                                   [self.navigationController popViewControllerAnimated:YES];
                                                   [self.delegate cancelParty:self.party with:self.intoType];
                                               }
                                           } failure:^(NSError *error, NSURLSessionDataTask *task) {
                                               
                                           }];
               }];
}

- (void)shareParty {
    [SRNet_Manager requestNetWithDic:[SRNet_Manager sharePartyDic:self.party]
                            complete:^(NSString *msgString, id jsonDic, int interType, NSURLSessionDataTask *task) {
                                if (jsonDic) {
                                    //聚会分享获取链接成功
                                    //将聚会链接赋值到粘贴板
                                    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
                                    pboard.string = (NSString *)jsonDic;
                                    
                                    [SRTool showSRAlertOnlyTipWithTitle:@"提示" message:@"聚会链接已经复制到了粘贴板上啦!"];
                                }
                            } failure:^(NSError *error, NSURLSessionDataTask *task) {
                                
                            }];
}

- (void)addToEvent {
    //事件市场
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    //6.0及以上通过下面方式写入事件
    if ([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)])
    {
        // the selector is available, so we must be on iOS 6 or newer
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    //错误信息
                    // display error message here
                } else if (!granted) {
                    //被用户拒绝，不允许访问日历
                    // display access denied error message here
                } else {
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
                    
                    
                    if (!err) {
                        
                    }
                    [SRTool showSRAlertViewWithTitle:@"提示" message:@"聚会已经成功添加到日程~\n"
                                   cancelButtonTitle:@"好的"
                                    otherButtonTitle:nil
                               tapCancelButtonHandle:^(NSString *msgString) {
                                   
                               } tapOtherButtonHandle:^(NSString *msgString) {
                                   
                               }];
                }
            });
        }];
    }
}

- (IBAction)tapBackButton:(id)sender {
       [self.navigationController popViewControllerAnimated:YES];
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

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([@"GoToPay" isEqualToString:identifier]) {
        if (self.party.pay_amount) {
            return NO;
        } else {
            return YES;
        }
    }
    return YES;
}

- (void)inputAmount:(NSNumber *)amount {
    [SVProgressHUD showSuccessWithStatus:@"正在处理付款信息" maskType:SVProgressHUDMaskTypeGradient];
    self.party.pay_amount = amount;
    //只发送修改的关键部分
    Model_Party *sendParty = [[Model_Party alloc] init];
    sendParty.pk_party = self.party.pk_party;
    sendParty.pay_amount = amount;
    sendParty.pay_fk_user = [Model_User loadFromUserDefaults].pk_user;
    //输入结账完成,这里将做结账处理
    [SRNet_Manager requestNetWithDic:[SRNet_Manager settleParty:sendParty] complete:^(NSString *msgString, id jsonDic, int interType, NSURLSessionDataTask *task) {
        //返回结账信息成功.
        [SVProgressHUD showSuccessWithStatus:@"标注支付完成"];
        
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
        PartyMapViewController *childController = (PartyMapViewController *)segue.destinationViewController;
        childController.party = self.party;
    } else if([segue.identifier isEqualToString:@"INBUTTON"]) {
        NSLog(@"进入参与界面");
        
        UIButton *pressedButton = (UIButton *)sender;
        PartyPeopleListViewController *childController = (PartyPeopleListViewController *)[segue destinationViewController];
        childController.party = self.party;
        childController.isCreator = [SRTool partyCreatorIsSelf:self.party];
        childController.isPayor = [SRTool partyPayorIsSelf:self.party];
        childController.showStatus = (int)pressedButton.tag;
        childController.relationArray = _relArray;
    }else if ([segue.identifier isEqualToString:@"OUTBUTTON"]) {
        NSLog(@"进入拒绝界面");
        UIButton *pressedButton = (UIButton *)sender;
        PartyPeopleListViewController *childController = (PartyPeopleListViewController *)[segue destinationViewController];
        childController.party = self.party;
        childController.isCreator = [SRTool partyCreatorIsSelf:self.party];
        childController.isPayor = [SRTool partyPayorIsSelf:self.party];
        childController.showStatus = (int)pressedButton.tag;
        childController.relationArray = _relArray;

        
    }else if([segue.identifier isEqualToString:@"UNKNOWBUTTON"]) {
        NSLog(@"进入不确定界面");
        UIButton *pressedButton = (UIButton *)sender;
        PartyPeopleListViewController *childController = (PartyPeopleListViewController *)[segue destinationViewController];
        childController.party = self.party;
        childController.isCreator = [SRTool partyCreatorIsSelf:self.party];
        childController.isPayor = [SRTool partyPayorIsSelf:self.party];
        childController.showStatus = (int)pressedButton.tag;
        childController.relationArray = _relArray;

    }else if([segue.identifier isEqualToString:@"GoToPay"]){
        PrepayViewController *childController = (PrepayViewController *)segue.destinationViewController;
        [childController setDelegate:self];
    }
}


@end
