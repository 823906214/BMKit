//
//  BMView.h
//  BlackMoomKit
//
//  Created by 朱锦栋 on 2020/10/9.
//  Copyright © 2020 朱锦栋. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BMView : UIView

/**
 点击事件
 @param block 点击事件回调
 */
- (void)bm_clickEventBlock:(void(^)(UITapGestureRecognizer * gesture))block;

/**
 设置某个圆角
 
 @param corners UIRectCornerTopLeft|UIRectCornerTopRight |连接，设置左右
 @param cornerRadius 圆角角度
 */
- (void)pathWithRoundedRect:(UIRectCorner)corners cornerRadius:(CGFloat )cornerRadius;

/**
 设置圆角和阴影
 
 @param radius 圆角
 @param shadowColor 阴影颜色
 @param shadowRadius 阴影圆角
 @param shadowOffset 偏移
 @param shadowOpacity 阴影透明度
 */
- (void)setShadowWithcornerRadius:(CGFloat)radius shadowColor:(UIColor *)shadowColor shadowRadius:(CGFloat)shadowRadius shadowOffset:(CGSize)shadowOffset shadowOpacity:(CGFloat)shadowOpacity;



@end

NS_ASSUME_NONNULL_END
