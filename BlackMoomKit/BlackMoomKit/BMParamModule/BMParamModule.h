//
//  BMParamModule.h
//  BlackMoomKit
//  流程-用于长流程的数据传递
// 比如初始进去，到流程结束。原来如果最后的页面需要第一个页面的参数就必须一层一层的传下去。这边是直接单例去取数据。避免由于中间某一层没有传导致流程失败。
//  Created by 朱锦栋 on 2020/12/4.
//  Copyright © 2020 朱锦栋. All rights reserved.
//

/***
 当前问题:
 1.按照这样进行编码，不利于后期维护以及合作。最好是有model。
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BMParamModule : NSObject


+(id)shareParamModule;

/// 根据流程初始化
/// @param name 自定义业务标志
-(BOOL)startWithName:(NSString *)name;


/// 设置其中步骤传递的数据
/// @param params 数据
/// @param step 步骤
-(void)setParams:(id)params atStep:(NSString *)step ;


/// 获取步骤传递的数据
/// @param step 步骤
-(id)paramsOfStep:(NSString *)step;


/// 获取多个步骤传递的数据
/// @param steps 步骤
-(id)paramsOfSteps:(NSArray *)steps;


/// 流程完成，执行清除数据操作。
-(BOOL)completeStep;

//-(void)startWithParams:(id)params;

@end

NS_ASSUME_NONNULL_END
