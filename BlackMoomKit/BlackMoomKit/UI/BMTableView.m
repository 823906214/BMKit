//
//  BMTableView.m
//  BlackMoomKit
//
//  Created by 朱锦栋 on 2020/10/9.
//  Copyright © 2020 朱锦栋. All rights reserved.
//

#import "BMTableView.h"

@interface BMTableView ()

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) NSInteger pageSize;

@end

@implementation BMTableView

-(instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+(BMTableView *)newNoPageTable{
    BMTableView *tableView = [[BMTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.pageEnable = NO;
    return tableView;
}

+(BMTableView *)newPageEnableTable{
    BMTableView *tableView = [[BMTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.pageEnable = YES;
    return tableView;
}


-(void)layoutSubviews{
    [super layoutSubviews];
    if (!self.pageEnable) {
        self.headView = nil;
    }
}

//设置是否分页
-(void)setPageEnable:(BOOL)pageEnable{
    //
}

- (void)setHeadView:(id<BMTableViewHeaderHandle>)headView{
    _headView = headView;
    if (headView) {
        headView.refreshBlock = ^{
          //开始刷新
            self.page = 1;
            if (self.pageDelegate && [self.pageDelegate respondsToSelector:@selector(bmTableViewRequestDataWithPage:pagesize:handle:)]) {
                [self.pageDelegate bmTableViewRequestDataWithPage:1 pagesize:self.pageSize handle:^{
                    //成功或失败回调，取消刷新加载动画
                }];
            }
        };
    }
}

@end
