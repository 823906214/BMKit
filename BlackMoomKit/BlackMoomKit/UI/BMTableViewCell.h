//
//  BMTableViewCell.h
//  BlackMoomKit
//
//  Created by 朱锦栋 on 2020/10/9.
//  Copyright © 2020 朱锦栋. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BMTableViewCell : UITableViewCell

/**
 功能计划:
 1.弱引用tableView
 2.修改数据源后手动调用单cell刷新
 ***/

/// 根据数据源刷新cell内容
-(void)refreshCellData;

@end

NS_ASSUME_NONNULL_END
