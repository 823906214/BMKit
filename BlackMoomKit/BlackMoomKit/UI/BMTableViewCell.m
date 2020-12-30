//
//  BMTableViewCell.m
//  BlackMoomKit
//
//  Created by 朱锦栋 on 2020/10/9.
//  Copyright © 2020 朱锦栋. All rights reserved.
//

#import "BMTableViewCell.h"

@implementation BMTableViewCell

-(void)willMoveToSuperview:(UIView *)newSuperview{
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/// 根据数据源刷新cell内容
-(void)refreshCellData{
    UITableView *tableView = [self currentTable];
    if(tableView){
        //去刷新
    }
}


/// 获取当前cell的tableView
-(UITableView *)currentTable{
    return nil;
}

@end
