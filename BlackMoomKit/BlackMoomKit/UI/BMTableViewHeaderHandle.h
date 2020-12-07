//
//  BMTableViewHeaderHandle.h
//  BlackMoomKit
//
//  Created by 朱锦栋 on 2020/12/4.
//  Copyright © 2020 朱锦栋. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^BegainRefreshBlock)(void);
NS_ASSUME_NONNULL_BEGIN

@protocol BMTableViewHeaderHandle <NSObject>

@property (nonatomic, copy) BegainRefreshBlock refreshBlock;

@end

NS_ASSUME_NONNULL_END
