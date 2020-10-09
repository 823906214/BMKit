//
//  UIView+Config.m
//  BlackMoomKit
//
//  Created by 朱锦栋 on 2019/3/21.
//  Copyright © 2019 朱锦栋. All rights reserved.
//

#import "UIView+Config.h"
#import <objc/runtime.h>


@implementation UIView (Config)

-(void)setConfig:(BMKitBaseConfig *)config{
    objc_setAssociatedObject(self, @selector(config), config, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    unsigned int numIvars;
    Ivar *vars = class_copyIvarList([BMKitBaseConfig class], &numIvars);
    NSString *key=nil;
    for(int i = 0; i < numIvars; i++) {
        Ivar thisIvar = vars[i];
        key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
        id value = object_getIvar(config, thisIvar);
        key = [key stringByReplacingOccurrencesOfString:@"_" withString:@""];
        SEL sel = NSSelectorFromString([NSString stringWithFormat:@"_set%@:",[self capitalizedString:key]]);
        if([self respondsToSelector:sel]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self performSelector:sel withObject:value];
#pragma clang diagnostic pop
        }
    }
    free(vars);
}

-(NSString *)capitalizedString:(NSString *)string{
    NSString*resultStr;
    if(string && string.length>0) {
        resultStr = [string stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[string substringToIndex:1] capitalizedString]];
        
    }
    return resultStr;
}

-(BMKitBaseConfig *)config{
    return objc_getAssociatedObject(self, @selector(config));
}

@end
