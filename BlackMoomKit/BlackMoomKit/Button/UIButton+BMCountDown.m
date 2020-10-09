//
//  UIButton+BMCountDown.m
//  BlackMoomKit
//
//  Created by 朱锦栋 on 2019/3/25.
//  Copyright © 2019 朱锦栋. All rights reserved.
//

#import "UIButton+BMCountDown.h"
#import "BMGCDTimer.h"
#import <objc/runtime.h>

@interface UIButton()

@property (nonatomic, copy) StyleBlock nomalStyle;

@property (nonatomic, copy) StyleBlock selectStyle;

@property (nonatomic, strong) NSString *formatter;

@property (nonatomic, assign) NSTimeInterval countTimer;

@end

@implementation UIButton (BMCountDown)


/**
 配置倒计时参数
 
 @param formatter 文本格式
 @param nomalStyle 未点击样式
 @param selectStyle 选择样式
 @param count 倒计时
 */
-(void)configCountDownButtonWithStringFormatter:(NSString *)formatter
                                     nomalStyle:(StyleBlock)nomalStyle
                                    selectStyle:(StyleBlock)selectStyle
                                      timeCount:(NSTimeInterval)count{
    self.formatter = formatter;
    self.nomalStyle = nomalStyle;
    self.selectStyle = selectStyle;
    self.countTimer = count;
    nomalStyle(self);
//    BMGCDTimer *timer = [BMGCDTimer scheduledTimerWithTotalTimer:count block:^(NSTimeInterval timer) {
//
//    }];
}

-(void)startCountDown{
    self.userInteractionEnabled = NO;
    [BMGCDTimer scheduledTimerWithTotalTimer:self.countTimer block:^(NSTimeInterval timer) {
        if (timer == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.userInteractionEnabled = YES;
                self.nomalStyle(self);
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                self.selectStyle(self);
                [self setTitle:[NSString stringWithFormat:self.formatter,@(timer).stringValue] forState:UIControlStateNormal];
            });
        }
    }];
}



-(void)setSelectStyle:(StyleBlock)selectStyle{
    objc_setAssociatedObject(self, @selector(selectStyle), selectStyle, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(StyleBlock)selectStyle{
    return objc_getAssociatedObject(self, @selector(selectStyle));
}


-(void)setNomalStyle:(StyleBlock)nomalStyle{
    objc_setAssociatedObject(self, @selector(nomalStyle), nomalStyle, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(StyleBlock)nomalStyle{
    return objc_getAssociatedObject(self, @selector(nomalStyle));
}

-(void)setFormatter:(NSString *)formatter{
    objc_setAssociatedObject(self, @selector(formatter), formatter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSString *)formatter{
    return objc_getAssociatedObject(self, @selector(formatter));
}

-(void)setCountTimer:(NSTimeInterval)countTimer{
    objc_setAssociatedObject(self, @selector(countTimer), @(countTimer), OBJC_ASSOCIATION_ASSIGN);
}

-(NSTimeInterval)countTimer{
    NSNumber *number = objc_getAssociatedObject(self, @selector(countTimer));
    return number.doubleValue;
}



@end
