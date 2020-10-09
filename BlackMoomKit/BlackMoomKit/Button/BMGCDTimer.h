//
//  BMGCDTimer.h
//  BlackMoomKit
//
//  Created by 朱锦栋 on 2019/3/25.
//  Copyright © 2019 朱锦栋. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BMGCDTimer : NSObject

+(void)scheduledTimerWithTotalTimer:(NSTimeInterval)interval block:(void (^)(NSTimeInterval timer))block;

+(void)scheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(void (^)(NSTimeInterval timer))block;

@end

NS_ASSUME_NONNULL_END
