//
//  UILabel+LineSpacing.m
//  MYKitDemo
//
//  Created by QMMac on 2018/7/20.
//  Copyright © 2018 com.51fanxing. All rights reserved.
//

#import "UILabel+LineSpacing.h"
#import "NSObject+Swizzle.h"
#import "NSString+Size.h"

@implementation UILabel (LineSpacing)

static char *lineSpaceKey;

+ (void)registerLineSpacingSelector {
    
    // 防御对象实例方法
    [self instanceSwizzleMethod:@selector(setText:) replaceMethod:@selector(setHasLineSpaceText:)];
}

// 设置带有行间距的文本。
- (void)setHasLineSpaceText:(NSString *)text {
    
    if (!text.length || self.lineSpace == 0) {
        [self setHasLineSpaceText:text];
        return;
    }

    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = self.lineSpace - (self.font.lineHeight - self.font.pointSize);
    paragraphStyle.lineBreakMode = self.lineBreakMode;
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    self.attributedText = [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (void)setLineSpace:(CGFloat)lineSpace {
    
    objc_setAssociatedObject(self, &lineSpaceKey, @(lineSpace), OBJC_ASSOCIATION_ASSIGN);
    self.text = self.text;
}

- (CGFloat)lineSpace {
    return [objc_getAssociatedObject(self, &lineSpaceKey) floatValue];
}

@end

