//
//  UIView+Badge.m
//  MYKitDemo
//
//  Created by sunjinshuai on 2017/12/29.
//  Copyright © 2017年 com.51fanxing. All rights reserved.
//

#import "UIView+Badge.h"
#import <objc/runtime.h>

#define ITGBadgeTextLayerFont               [UIFont systemFontOfSize:8]
#define ITGBadgeTextLayerPadding            2

static const char *kBadgeValueTextLayerKey = "BadgeValueTextLayerKey";

@interface UIView ()

@end

@implementation UIView (Badge)

- (void)addBadgeWithRadius:(CGFloat)radius
                   offsetX:(CGFloat)offsetX
                   offsetY:(CGFloat)offsetY {
    CATextLayer *badgeLayer = [self badgeLayer];
    
    if (badgeLayer) {
        [badgeLayer removeFromSuperlayer];
    }
    CATextLayer *layer      = [CATextLayer layer];
    layer.frame             = CGRectMake(-radius + offsetX,
                                         -radius + offsetY,
                                         radius * 2,
                                         radius * 2);
    layer.backgroundColor   = [UIColor redColor].CGColor;
    layer.cornerRadius      = radius;
    layer.hidden            = YES;
    [self setBadgeLayer:layer];
    [self.layer addSublayer:layer];
}

- (void)showBadgeWithRadius:(CGFloat)radius
                    offsetX:(CGFloat)offsetX
                    offsetY:(CGFloat)offsetY {
    
    CATextLayer *badgeLayer = [self badgeLayer];
    
    if (badgeLayer) {
        [badgeLayer removeFromSuperlayer];
    }
    
    CATextLayer *layer      = [CATextLayer layer];
    layer.frame             = CGRectMake(-radius + offsetX,
                                         -radius + offsetY,
                                         radius * 2,
                                         radius * 2);
    layer.backgroundColor   = [UIColor redColor].CGColor;
    layer.cornerRadius      = radius;
    [self setBadgeLayer:layer];
    [self.layer addSublayer:layer];
}

- (void)showBadgeValue:(NSString *)badgeValue
               offsetX:(CGFloat)offsetX
               offsetY:(CGFloat)offsetY {
    
    CATextLayer *badgeLayer = [self badgeLayer];
    
    if (badgeLayer) {
        [badgeLayer removeFromSuperlayer];
    }
    
    CGSize expectedLabelSize = [badgeValue boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                     attributes:@{
                                                                  NSFontAttributeName:ITGBadgeTextLayerFont
                                                                  }
                                                        context:nil].size;
    CGFloat minHeight        = expectedLabelSize.height;
    CGFloat minWidth         = expectedLabelSize.width;
    minWidth                 = (minWidth < minHeight) ? minHeight : expectedLabelSize.width;
    CATextLayer *layer       = [CATextLayer layer];
    layer.frame              = CGRectMake(offsetX,
                                          offsetY,
                                          minWidth + ITGBadgeTextLayerPadding,
                                          minHeight + ITGBadgeTextLayerPadding);
    layer.string             = badgeValue;
    layer.backgroundColor    = [UIColor redColor].CGColor;
    layer.foregroundColor    = [UIColor whiteColor].CGColor;
    layer.alignmentMode      = kCAAlignmentCenter;
    CFStringRef fontName     = (__bridge CFStringRef)ITGBadgeTextLayerFont.fontName;
    layer.font               = CGFontCreateWithFontName(fontName);
    layer.fontSize           = ITGBadgeTextLayerFont.pointSize;
    layer.contentsScale      = [UIScreen mainScreen].scale;
    layer.cornerRadius       = (minHeight + ITGBadgeTextLayerPadding) / 2;
    [self setBadgeLayer:layer];
    [self.layer addSublayer:layer];
}

- (void)showBadge {
    CATextLayer *badgeLayer  = [self badgeLayer];
    if (badgeLayer) {
        badgeLayer.hidden    = NO;
    }
}

- (void)hiddenBadge {
    CATextLayer *badgeLayer  = [self badgeLayer];
    if (badgeLayer) {
        badgeLayer.hidden    = YES;
    }
}

#pragma mark - getter & setter
- (CATextLayer *)badgeLayer {
    return objc_getAssociatedObject(self, kBadgeValueTextLayerKey);
}

- (void)setBadgeLayer:(CATextLayer *)layer {
    objc_setAssociatedObject(self, kBadgeValueTextLayerKey, layer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
