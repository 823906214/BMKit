//
//  UIButton+BMCountDown.h
//  BlackMoomKit
//  按钮倒计时
//  Created by 朱锦栋 on 2019/3/25.
//  Copyright © 2019 朱锦栋. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^StyleBlock)(UIButton *button);

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (BMCountDown)


/**
 配置倒计时参数

 @param formatter 文本格式
 @param nomalStyle 未点击样式
 @param selectStyle 选择样式
 @param count 倒计时
 */
-(void)configCountDownButtonWithStringFormatter:(NSString *)formatter
                                 nomalStyle:(StyleBlock )nomalStyle
                                selectStyle:(StyleBlock )selectStyle
                                      timeCount:(NSTimeInterval)count;


-(void)startCountDown;
@end

NS_ASSUME_NONNULL_END
