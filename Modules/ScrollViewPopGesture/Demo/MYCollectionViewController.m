//
//  MYCollectionViewController.m
//  MYPerformanceKit
//
//  Created by sunjinshuai on 2019/4/24.
//  Copyright © 2019 sunjinshuai. All rights reserved.
//

#import "MYCollectionViewController.h"
#import "UIViewController+PopGesture.h"

@interface MYCollectionViewController ()

@end

@implementation MYCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configCollectionView];
}

- (void)configCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64) collectionViewLayout:layout];
    collectionView.contentSize = CGSizeMake(1000, 0);
    collectionView.backgroundColor = [UIColor magentaColor];
    [self.view addSubview:collectionView];
    
    // collectionView需要支持侧滑返回
    [self addPopGestureToView:collectionView];
}


@end
