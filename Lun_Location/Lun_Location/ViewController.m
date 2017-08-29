//
//  ViewController.m
//  Lun_Location
//
//  Created by 小伦 on 2017/8/9.
//  Copyright © 2017年 小伦. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController ()<CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *wLab;
@property (weak, nonatomic) IBOutlet UILabel *hLab;
@property (weak, nonatomic) IBOutlet UILabel *locLab;
@property (weak, nonatomic) IBOutlet UILabel *stateLab;
@property (weak, nonatomic) IBOutlet UILabel *cityLab;
@property (weak, nonatomic) IBOutlet UILabel *subCityLab;
@property (weak, nonatomic) IBOutlet UILabel *streetLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *postLab;

@property (strong, nonatomic) CLLocationManager *locationMgr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (CLLocationManager *)locationMgr{
    if (!_locationMgr) {
        _locationMgr = [[CLLocationManager alloc] init];
        _locationMgr.delegate = self;
        if ([self.locationMgr respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self .locationMgr requestWhenInUseAuthorization];
        }
        _locationMgr.desiredAccuracy = kCLLocationAccuracyBest; //精确度要求
        _locationMgr.distanceFilter = 10.f;//距离更新
    }
    return _locationMgr;
}

- (IBAction)beginLocation:(id)sender {
    
    [self.locationMgr startUpdatingLocation];//开始定位
}
- (IBAction)endLocation:(id)sender {
    [self.locationMgr stopUpdatingLocation]; //结束定位
}

/**
 代理方法

 @param manager locationMgr
 @param locations locationMgr.location
 */
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    CLLocation *loc = [locations objectAtIndex:0];
    CGFloat l = loc.coordinate.longitude; //经度
    CGFloat w = loc.coordinate.latitude;  //纬度
    self.wLab.text = [NSString stringWithFormat:@"%.4f",w];
    self.hLab.text = [NSString stringWithFormat:@"%.4f",l];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];  //地理编码
    [geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (!error) {
            for (CLPlacemark *placemark in placemarks) {
//                NSDictionary *addressDic = placemark.addressDictionary;
                NSString *name = placemark.name; //单位名称
                NSString *thoroughfare = placemark.thoroughfare; //街道名称
                NSString *subThoroughfare = placemark.subThoroughfare;//门牌号
                NSString *locality = placemark.locality; //城市
                NSString *subLocality = placemark.subLocality; //县、区
                NSString *administrativeArea = placemark.administrativeArea;//省
                NSString *postalCode = placemark.postalCode;//邮政编码
                NSString *ISOcountryCode = placemark.ISOcountryCode;//国家缩写
                NSString *country = placemark.country;//国家全称
                NSString *inlandWater = placemark.inlandWater; //流域
                NSString *ocean = placemark.ocean;//海洋
                NSArray<NSString *> *areasOfInterest = placemark.areasOfInterest;//别名
                self.locLab.text = ISOcountryCode;
                self.stateLab.text = administrativeArea;
                self.cityLab.text = locality;
                self.subCityLab.text = subLocality;
                self.streetLab.text = thoroughfare;
                self.numLab.text = subThoroughfare;
                self.nameLab.text = name;
                self.postLab.text = postalCode;
                NSLog(@"%s__%d__|addressDic=%@",__FUNCTION__,__LINE__,placemark.addressDictionary);
                for (NSString *area in areasOfInterest) {
                    NSLog(@"%s__%d__|area = %@",__FUNCTION__,__LINE__,area);
                }
                
            }
        }else{
            NSLog(@"%s__%d__|error=%@",__FUNCTION__,__LINE__,error);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
