//
//  MYMapViewController.m
//  MYPerformanceKit
//
//  Created by sunjinshuai on 2019/4/24.
//  Copyright © 2019 sunjinshuai. All rights reserved.
//

#import "MYMapViewController.h"
#import "UIViewController+PopGesture.h"
#import <MapKit/MapKit.h>

@interface MYMapViewController ()

@end

@implementation MYMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configMapView];
}

- (void)configMapView {
    MKMapView *mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
    [self.view addSubview:mapView];
    
    // mapView需要支持侧滑返回
    [self addPopGestureToView:mapView];
}

@end
