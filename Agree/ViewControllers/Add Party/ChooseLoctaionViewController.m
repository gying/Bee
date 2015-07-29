//
//  ChooseLoctaionViewController.m
//  SRAgree
//
//  Created by G4ddle on 14/12/16.
//  Copyright (c) 2014年 G4ddle. All rights reserved.
//

#import "ChooseLoctaionViewController.h"
#import "ChooseDateViewController.h"
#import "Model_Party.h"
#import <BaiduMapAPI/BMapKit.h>

#import "ConfirmPartyDetailViewController.h"

@interface ChooseLoctaionViewController () <BMKLocationServiceDelegate, BMKMapViewDelegate, BMKGeoCodeSearchDelegate, UITextFieldDelegate> {
    BMKMapView *_bdMapView;
    BMKLocationService *_locService;
    BMKPointAnnotation *_chooseAnnotation;
    BMKGeoCodeSearch *_searcher;
    BMKPinAnnotationView *_choosePin;
    BOOL _mapViewSetCenter;
    
    ConfirmPartyDetailViewController * cfpdVC;
    
}

@end

@implementation ChooseLoctaionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _bdMapView = [[BMKMapView alloc]initWithFrame:self.view.frame];
//    [self.mapView addSubview:_bdMapView];
    [self.mapView addSubview:_bdMapView];
    
    
    if (self.party.longitude && self.party.latitude) {
        CLLocationCoordinate2D pointCoor;
        pointCoor.longitude = self.party.longitude.floatValue;
        pointCoor.latitude = self.party.latitude.floatValue;
        
        if (!_chooseAnnotation) {
            _chooseAnnotation = [[BMKPointAnnotation alloc]init];
        }
        
        
        _chooseAnnotation.coordinate = pointCoor;
        _chooseAnnotation.title = @"点选位置";
        [_bdMapView addAnnotation:_chooseAnnotation];
        
        self.addressTextField.text = self.party.location;
        
    }
    //如果有默认位置,则指定默认位置
    CLLocationCoordinate2D userCoor;
    userCoor.longitude = [[[NSUserDefaults standardUserDefaults] objectForKey:@"user_location_long"] doubleValue];
    userCoor.latitude = [[[NSUserDefaults standardUserDefaults] objectForKey:@"user_location_lat"] doubleValue];
    if (userCoor.longitude && userCoor.latitude) {
        _bdMapView.centerCoordinate = userCoor;
    }
    _bdMapView.delegate = self;
    _mapViewSetCenter = false;
    
    
    //设置定位精确度，默认：kCLLocationAccuracyBest
    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    //指定最小距离更新(米)，默认：kCLDistanceFilterNone
    [BMKLocationService setLocationDistanceFilter:100.f];
    
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
}

//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
//    NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    _bdMapView.showsUserLocation = YES;//显示定位图层
    [_bdMapView updateLocationData:userLocation];

    if (!_mapViewSetCenter) {
        _mapViewSetCenter = true;
        [self performSelector:@selector(setMapViewZoomLevel:)
                   withObject:@15
                   afterDelay:0.5];
        [_bdMapView setCenterCoordinate:CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude) animated:YES];
        [_locService stopUserLocationService];
        
    }
    
    //设置用户默认位置
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:userLocation.location.coordinate.latitude] forKey:@"user_location_lat"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:userLocation.location.coordinate.longitude]  forKey:@"user_location_long"];
    

}


- (void)setMapViewZoomLevel: (NSNumber *)zoom {
    [_bdMapView setZoomLevel:zoom.intValue];
}

- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate {
    
    if (!_chooseAnnotation) {
        _chooseAnnotation = [[BMKPointAnnotation alloc]init];
    }
    
    
    _chooseAnnotation.coordinate = coordinate;
    _chooseAnnotation.title = @"点选位置";
    [_bdMapView addAnnotation:_chooseAnnotation];
    
    
    //初始化检索对象
    if (!_searcher) {
        _searcher =[[BMKGeoCodeSearch alloc]init];
        _searcher.delegate = self;
    }
    //发起反向地理编码检索
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = coordinate;
    BOOL flag = [_searcher reverseGeoCode:reverseGeoCodeSearchOption];

    if(flag) {
//      NSLog(@"反geo检索发送成功");
    } else {
//      NSLog(@"反geo检索发送失败");
    }
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        if (_choosePin) {
            _choosePin = nil;
        }
        //设置图钉信息
        _choosePin = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"choosePin"];
        _choosePin.annotation = annotation;
        _choosePin.pinColor = BMKPinAnnotationColorRed;
        _choosePin.animatesDrop = YES;// 设置该标注点动画显示
        return _choosePin;
    }
    return nil;
   
    
    
    
}

//接收反向地理编码结果
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:
(BMKReverseGeoCodeResult *)result
errorCode:(BMKSearchErrorCode)error{
  if (error == BMK_SEARCH_NO_ERROR) {
      _chooseAnnotation.title = result.address;
      self.addressTextField.text = result.address;
  }
  else {
      NSLog(@"抱歉，未找到结果");
  }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_bdMapView viewWillAppear];
    _bdMapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
    _searcher.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated {
    //在推出时候清空
    [_bdMapView viewWillDisappear];
    _bdMapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
    _searcher.delegate = nil;
    [super viewWillDisappear:animated];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return [textField resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)tapBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if (self.fromRoot) {
        ConfirmPartyDetailViewController *rootController = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 2];
        
        
        rootController.party.longitude = [NSNumber numberWithDouble:_chooseAnnotation.coordinate.longitude];
        rootController.party.latitude = [NSNumber numberWithDouble:_chooseAnnotation.coordinate.latitude];
        rootController.party.location = self.addressTextField.text;
        [rootController reloadView];
        [self.navigationController popViewControllerAnimated:YES];
        return NO;
    }
    

    
    return YES;
}


#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    Model_Party *newParty = [[Model_Party alloc] init];
    newParty.fk_group = self.chooseGroup.pk_group;
    newParty.longitude = [NSNumber numberWithDouble:_chooseAnnotation.coordinate.longitude];
    newParty.latitude = [NSNumber numberWithDouble:_chooseAnnotation.coordinate.latitude];
    newParty.location = self.addressTextField.text;
    
    ChooseDateViewController *controller = (ChooseDateViewController *)segue.destinationViewController;
    controller.party = newParty;
    controller.isGroupParty = self.isGroupParty;
 
}


@end
