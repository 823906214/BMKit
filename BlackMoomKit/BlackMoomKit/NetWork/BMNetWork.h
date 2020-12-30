//
//  BMNetWork.h
//  BlackMoomKit
//
//  Created by 朱锦栋 on 2020/12/4.
//  Copyright © 2020 朱锦栋. All rights reserved.
//

/***
 封装afnetworking
 1.请求取消，请求竞争
 2.加密支持
 3.支持多请求地址
 4.支持环境切换
 5.开放缓存接口
 6.添加基本请求方法(GET,POST,PUT,DELETE)--基本只用到GET和POST
 
 
 
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BMNetWork : NSObject

@end

NS_ASSUME_NONNULL_END
