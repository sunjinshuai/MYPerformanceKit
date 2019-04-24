//
//  MYPageViewController.h
//  MYPerformanceKit
//
//  Created by sunjinshuai on 2019/4/24.
//  Copyright © 2019 sunjinshuai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MYPageViewController : UIViewController

@end

@interface MYSubScrollViewController : UIViewController

@property (nonatomic, strong) UIScrollView *scrollView;

@end

NS_ASSUME_NONNULL_END
