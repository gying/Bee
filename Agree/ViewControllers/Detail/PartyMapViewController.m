//
//  PartyMapViewController.m
//  Agree
//
//  Created by G4ddle on 15/4/4.
//  Copyright (c) 2015年 superRabbit. All rights reserved.
//

#import "PartyMapViewController.h"
#import <BaiduMapAPI/BMapKit.h>
#import "SRTool.h"

@interface PartyMapViewController ()<BMKLocationServiceDelegate, BMKMapViewDelegate> {
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

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {
    

   BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];

    [newAnnotationView setFrame:CGRectMake(newAnnotationView.frame.origin.x, newAnnotationView.frame.origin.y,35,35)];
    
    [newAnnotationView setEnabled:YES];
    [newAnnotationView setContentMode:UIViewContentModeScaleAspectFit];
    customButton = [[UIButton alloc]initWithFrame:CGRectMake(-6.55,-3,45,45)];
    customButton.backgroundColor = [UIColor clearColor];
    [customButton addTarget:self action:@selector(navi) forControlEvents:UIControlEventTouchUpInside];
    [customButton setImage:[UIImage imageNamed:@"sr_map_point"] forState:UIControlStateNormal];
//    BMKActionPaopaoView * paopaoView = [[BMKActionPaopaoView alloc]initWithCustomView:customButton];
//    newAnnotationView.paopaoView = paopaoView;
    newAnnotationView.backgroundColor = [UIColor clearColor];
    [newAnnotationView addSubview:customButton];
    return newAnnotationView;
    
    
}

-(void)navi {
    [self topNavi:nil];
    
}


//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    _bdMapView.showsUserLocation = YES;//显示定位图层
    [_bdMapView updateLocationData:userLocation];
    
    
    _userLocation = userLocation;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)topNavi:(id)sender {
    [self availableMapsApps];
    
    NSMutableArray *buttonTitleAry = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in self.availableMaps) {
        //        [action addButtonWithTitle:[NSString stringWithFormat:@"%@", dic[@"name"]]];
        [buttonTitleAry addObject:[NSString stringWithFormat:@"%@", dic[@"name"]]];
    }
    
    [SRTool showSRSheetInView:self.view withTitle:@"选择导航方式" message:@"选择一个已经存在于手机中的导航软件"
              withButtonArray:buttonTitleAry
              tapButtonHandle:^(int buttonIndex) {
                  NSDictionary *mapDic = self.availableMaps[buttonIndex];
                  NSString *urlString = mapDic[@"url"];
                  urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                  NSURL *url = [NSURL URLWithString:urlString];
                  //        DEBUG_LOG(@"\n%@\n%@\n%@", mapDic[@"name"], mapDic[@"url"], urlString);
                  [[UIApplication sharedApplication] openURL:url];
              } tapCancelHandle:^{
                  
              }];
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

- (IBAction)backButton:(id)sender {
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
