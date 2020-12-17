//
//  BMView.m
//  BlackMoomKit
//
//  Created by 朱锦栋 on 2020/10/9.
//  Copyright © 2020 朱锦栋. All rights reserved.
//

#import "BMView.h"
typedef void(^ViewTargetBlock)(UITapGestureRecognizer * gesture);
@interface BMView()

@property (nonatomic,copy) ViewTargetBlock viewTargetBlock;

@end
@implementation BMView

#pragma mark - click
- (void)bm_clickEventBlock:(void (^)(UITapGestureRecognizer * _Nonnull))block{
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] init];
    gesture.numberOfTapsRequired = 1;
    [gesture addTarget:self action:@selector(handlerWithViewTarget:)];
    [self addGestureRecognizer:gesture];
    self.viewTargetBlock = block;
}

- (void)handlerWithViewTarget:(UITapGestureRecognizer *)gesture{
    if (self.viewTargetBlock){
        self.viewTargetBlock(gesture);
    }
}

#pragma mark - radius 和 shadow
- (void)pathWithRoundedRect:(UIRectCorner)corners cornerRadius:(CGFloat )cornerRadius{
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(cornerRadius,cornerRadius)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    
    maskLayer.frame = self.bounds;
    
    maskLayer.path = maskPath.CGPath;
    
    self.layer.mask = maskLayer;
}

- (void)setShadowWithcornerRadius:(CGFloat)radius shadowColor:(UIColor *)shadowColor shadowRadius:(CGFloat)shadowRadius shadowOffset:(CGSize)shadowOffset shadowOpacity:(CGFloat)shadowOpacity{
    
    if (radius) {
        self.layer.cornerRadius = radius;
    }
    
    self.layer.backgroundColor = self.backgroundColor.CGColor;
    
    
    if (shadowColor) {
        self.layer.shadowColor = shadowColor.CGColor;
    }
    
    self.layer.shadowOffset = shadowOffset;
    
    if (shadowOpacity) {
        self.layer.shadowOpacity = shadowOpacity;
    }
    
    if (shadowRadius) {
        self.layer.shadowRadius = shadowRadius;
    }
}

@end
