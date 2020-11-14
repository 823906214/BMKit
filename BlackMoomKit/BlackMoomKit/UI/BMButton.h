//
//  BMButton.h
//  BlackMoomKit
//
//  Created by 朱锦栋 on 2020/10/9.
//  Copyright © 2020 朱锦栋. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    BMButtonRoutine, /**<  常规  图左文右 */
    BMButtonImageTop, /**<  图上文下*/
    BMButtonImageRight, /**<  图右文左*/
    BMButtonImageBelow, /**<  图下文上*/
}BMButtonType;
@interface BMButton : UIButton

/**
 设置点击区域大小
 @param top             点击区域到按钮顶部的距离
 @param right        点击区域到按钮右部的距离
 @param bottom      点击区域到按钮底部的距离
 @param left           点击区域到按钮左部的距离
 */
-(void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;

/**
 点击的block事件
 @param controlEvents 点击方法
 */
- (void)addTargetEventforControlEvents:(UIControlEvents)controlEvents block:(void (^)(UIButton * button))block;

/**
 图片位置
 */
@property (nonatomic,assign) BMButtonType imagePosition;

/**
 图片与文字间隔
 */
@property (nonatomic,assign) NSInteger space;



@end

NS_ASSUME_NONNULL_END
