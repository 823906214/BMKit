//
//  BMParamModule.m
//  BlackMoomKit
//
//  Created by 朱锦栋 on 2020/12/4.
//  Copyright © 2020 朱锦栋. All rights reserved.
//

#import "BMParamModule.h"

@interface BMParamModule ()

@property (nonatomic, strong) NSMutableDictionary *params;

@property (nonatomic, strong) NSMutableDictionary *currentParams;

@end

@implementation BMParamModule

+(id)shareParamModule{
    static BMParamModule *module = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        module = [[BMParamModule alloc] init];
    });
    return module;
}

/// 根据流程初始化
/// @param name 自定义业务标志
-(BOOL)startWithName:(NSString *)name{
    if ([self.params objectForKey:name]) {
        //如果已存在
        self.currentParams = [self.params objectForKey:name];
        return YES;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [self.params setObject:params forKey:name];
    self.currentParams = params;
    return YES;
}


/// 设置其中步骤传递的数据
/// @param params 数据
/// @param step 步骤
-(void)setParams:(id)params atStep:(NSString *)step{
    if (self.currentParams) {
        [self.currentParams setObject:params forKey:step];
    }
}


/// 获取步骤传递的数据
/// @param step 步骤
-(id)paramsOfStep:(NSString *)step{
    if (self.currentParams) {
        return [self.currentParams objectForKey:step];
    }
    return nil;
}


/// 获取多个步骤传递的数据
/// @param steps 步骤
-(id)paramsOfSteps:(NSArray *)steps{
    return nil;
}

@end
