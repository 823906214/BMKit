//
//  BMTableView.h
//  BlackMoomKit
//
//  Created by 朱锦栋 on 2020/10/9.
//  Copyright © 2020 朱锦栋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMTableViewHeaderHandle.h"
#import "BMTableViewFooterHandle.h"

typedef void(^RequestHandle)(void);

@protocol BMTableViewPageDelegate<NSObject>

-(void)bmTableViewRequestDataWithPage:(NSInteger)page pagesize:(NSInteger)pageSize handle:(RequestHandle _Nonnull )handle;

-(NSInteger)bmTableViewNumofPageSize;

@end



NS_ASSUME_NONNULL_BEGIN

@interface BMTableView : UITableView

/**
 功能计划:
 1.分页集成
 ***/

@property (nonatomic, weak) id<BMTableViewPageDelegate> pageDelegate;

@property (nonatomic, strong) id<BMTableViewHeaderHandle> headView;

@property (nonatomic, strong) id<BMTableViewFooterHandle> footerView;

@property (nonatomic, assign) BOOL pageEnable; //是否分页


/// 新建不分页tableView
+(BMTableView *)newNoPageTable;

/// 新建分页tableView
+(BMTableView *)newPageEnableTable;

@end

NS_ASSUME_NONNULL_END
