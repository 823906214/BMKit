//
//  BMGCDTimer.m
//  BlackMoomKit
//
//  Created by 朱锦栋 on 2019/3/25.
//  Copyright © 2019 朱锦栋. All rights reserved.
//

#import "BMGCDTimer.h"

@interface BMGCDTimer()

@property (nonatomic, assign) NSTimeInterval totalTime;

@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation BMGCDTimer

-(instancetype)initWithTimerInterval:(NSTimeInterval )timeInterval totalTimer:(NSTimeInterval )totalTimer block:(void (^)(NSTimeInterval timer))block{
    self = [super init];
    if (self) {
        self.totalTime = totalTimer;
        //创建队列
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, timeInterval * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
        dispatch_source_set_event_handler(self.timer, ^{
            if(self.totalTime<=0){ //倒计时结束，关闭
                //取消dispatch源
                block(0);
                dispatch_source_cancel(self.timer);
            }
            else{
                self.totalTime--;
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(self.totalTime);
                });
            }
        });
//        self.timer = timer;
//        dispatch_resume(timer);
    }
    return self;
}


+(void)scheduledTimerWithTotalTimer:(NSTimeInterval)interval block:(void (^)(NSTimeInterval timer))block{
    BMGCDTimer *timer = [[BMGCDTimer alloc] initWithTimerInterval:1 totalTimer:interval block:block];
    dispatch_resume(timer.timer);
}

+(void)scheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(void (^)(NSTimeInterval timer))block{
    BMGCDTimer *timer = [[BMGCDTimer alloc] initWithTimerInterval:interval totalTimer:NSIntegerMax block:block];
    dispatch_resume(timer.timer);
}

@end
