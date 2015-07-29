//
//  PartyMapViewController.m
//  Agree
//
//  Created by G4ddle on 15/4/4.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "PartyMapViewController.h"
#import <BaiduMapAPI/BMapKit.h>

@interface PartyMapViewController ()<BMKLocationServiceDelegate, UIActionSheetDelegate,BMKMapViewDelegate> {
    BMKMapView *_bdMapView;
    BMKLocationService *_locService;
    
    BMKUserLocation *_userLocation;
    BMKPointAnnotation *_chooseAnnotation;
    UIButton * customButton;
    
}

@end

@implementation PartyMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    if (self.party.longitude && self.party.latitude) {
        //如果存在经纬度数据
        //则开始更新地区信息
        _bdMapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
        [self.view addSubview:_bdMapView];
        [_bdMapView setDelegate:self];
        
        CLLocationCoordinate2D partyCoor;
        partyCoor.longitude = [self.party.longitude doubleValue];
        partyCoor.latitude = [self.party.latitude doubleValue];
        _chooseAnnotation = [[BMKPointAnnotation alloc] init];
        _chooseAnnotation.coordinate = partyCoor;
        _chooseAnnotation.title = @"聚会地点";
        [_bdMapView addAnnotation:_chooseAnnotation];
        [_bdMapView setZoomLevel:15];
        [_bdMapView setCenterCoordinate:partyCoor];


    }
    
    
    
    //设置定位精确度，默认：kCLLocationAccuracyBest
    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    //指定最小距离更新(米)，默认：kCLDistanceFilterNone
    [BMKLocationService setLocationDistanceFilter:100.f];
    
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
    
    self.availableMaps = [[NSMutableArray alloc] init];
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    

   BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];

    [newAnnotationView setFrame:CGRectMake(newAnnotationView.frame.origin.x, newAnnotationView.frame.origin.y,35,35)];
    
    [newAnnotationView setEnabled:YES];
    [newAnnotationView setContentMode:UIViewContentModeScaleAspectFit];
    customButton = [[UIButton alloc]initWithFrame:CGRectMake(-6.55,-3,45,45)];
    customButton.backgroundColor = [UIColor clearColor];
    [customButton addTarget:self action:@selector(daohang) forControlEvents:UIControlEventTouchUpInside];
    [customButton setImage:[UIImage imageNamed:@"sr_map_point"] forState:UIControlStateNormal];
//    BMKActionPaopaoView * paopaoView = [[BMKActionPaopaoView alloc]initWithCustomView:customButton];
//    newAnnotationView.paopaoView = paopaoView;
    newAnnotationView.backgroundColor = [UIColor clearColor];
    [newAnnotationView addSubview:customButton];
    return newAnnotationView;
    
    
}
-(void)daohang
{
    NSLog(@"导航");
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"选择导航方式"
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:nil];
    for (NSDictionary *dic in self.availableMaps) {
        [action addButtonWithTitle:[NSString stringWithFormat:@"%@", dic[@"name"]]];
    }
    [action showInView:self.view];
}


//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    _bdMapView.showsUserLocation = YES;//显示定位图层
    [_bdMapView updateLocationData:userLocation];
    
    
    _userLocation = userLocation;
//    if (!_mapViewSetCenter) {
//        _mapViewSetCenter = true;
//        [self performSelector:@selector(setMapViewZoomLevel:)
//                   withObject:@15
//                   afterDelay:0.5];
//        [_bdMapView setCenterCoordinate:CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude) animated:YES];
//    }
    
//    //设置用户默认位置
//    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:userLocation.location.coordinate.latitude] forKey:@"user_location_lat"];
//    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:userLocation.location.coordinate.longitude]  forKey:@"user_location_long"];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)topNavi:(id)sender {
//    NSMutableArray *nodesArray = [[NSMutableArray alloc] initWithCapacity: 2];
//    
//    //起点
//    BNRoutePlanNode *startNode = [[BNRoutePlanNode alloc] init];
//    startNode.pos = [[BNPosition alloc] init];
//    startNode.pos.x = 113.936392;
//    startNode.pos.y = 22.547058;
//    startNode.pos.eType = BNCoordinate_BaiduMapSDK;
//    [nodesArray addObject:startNode];
//    
//    //终点
//    BNRoutePlanNode *endNode = [[BNRoutePlanNode alloc] init];
//    endNode.pos = [[BNPosition alloc] init];
//    endNode.pos.x = 114.077075;
//    endNode.pos.y = 22.543634;
//    endNode.pos.eType = BNCoordinate_BaiduMapSDK;
//    [nodesArray addObject:endNode];
//    
//    // 发起算路
//    [BNCoreServices_RoutePlan  startNaviRoutePlan: BNRoutePlanMode_Recommend naviNodes:nodesArray time:nil delegete:self    userInfo:nil];
    
    
    
    [self availableMapsApps];
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"选择导航方式"
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:nil];
    
//    [action addButtonWithTitle:@"使用系统自带地图导航"];
    for (NSDictionary *dic in self.availableMaps) {
        [action addButtonWithTitle:[NSString stringWithFormat:@"%@", dic[@"name"]]];
    }
//    [action addButtonWithTitle:@"取消"];
//    action.cancelButtonIndex = self.availableMaps.count + 1;
//    action.delegate = self;
    [action showInView:self.view];
}

- (void)availableMapsApps {
    [self.availableMaps removeAllObjects];
    CLLocationCoordinate2D startCoor = _userLocation.location.coordinate;
    CLLocationCoordinate2D endCoor = _chooseAnnotation.coordinate;
    NSString *toName = @"聚会地点";
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://map/"]]){
        NSString *urlString = [NSString stringWithFormat:@"baidumap://map/direction?origin=latlng:%f,%f|name:我的位置&destination=latlng:%f,%f|name:%@&mode=driving",
                               startCoor.latitude, startCoor.longitude, endCoor.latitude, endCoor.longitude, toName];
        
        NSDictionary *dic = @{@"name": @"百度地图",
                              @"url": urlString};
        [self.availableMaps addObject:dic];
    }
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        NSString *urlString = [NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=applicationScheme&poiname=fangheng&poiid=BGVIS&lat=%f&lon=%f&dev=0&style=3",@"聚会", endCoor.latitude, endCoor.longitude];
        
        NSDictionary *dic = @{@"name": @"高德地图",
                              @"url": urlString};
        [self.availableMaps addObject:dic];
    }
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
        NSString *urlString = [NSString stringWithFormat:@"comgooglemaps://?saddr=&daddr=%f,%f¢er=%f,%f&directionsmode=transit", endCoor.latitude, endCoor.longitude, startCoor.latitude, startCoor.longitude];
        
        NSDictionary *dic = @{@"name": @"Google Maps",
                              @"url": urlString};
        [self.availableMaps addObject:dic];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (0 == buttonIndex) {
        //取消
    } else {
        NSDictionary *mapDic = self.availableMaps[buttonIndex - 1];
        NSString *urlString = mapDic[@"url"];
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:urlString];
        //        DEBUG_LOG(@"\n%@\n%@\n%@", mapDic[@"name"], mapDic[@"url"], urlString);
        [[UIApplication sharedApplication] openURL:url];
    }
}
- (IBAction)backButton:(id)sender {
    
    NSLog(@"返回");
    [self.navigationController popViewControllerAnimated:YES];
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
