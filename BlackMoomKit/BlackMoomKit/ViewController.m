//
//  ViewController.m
//  BlackMoomKit
//
//  Created by 朱锦栋 on 2019/3/21.
//  Copyright © 2019 朱锦栋. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Config.h"
#import "UIButton+BMCountDown.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *countDownButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [countDownButton configCountDownButtonWithStringFormatter:@"%@s" nomalStyle:^(UIButton *button) {
        [button setTitle:@"获取验证码" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    } selectStyle:^(UIButton *button) {
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    } timeCount:10];
    [countDownButton addTarget:self action:@selector(actionCountDown:) forControlEvents:UIControlEventTouchUpInside];
    countDownButton.frame = CGRectMake(100, 100, 100, 50);
    [self.view addSubview:countDownButton];
    
//    BlackMoomKitBaseConfig *config = [[BlackMoomKitBaseConfig alloc] init];
//    config.backgroundColor = [UIColor redColor];
//    self.view.config = config;
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)actionCountDown:(UIButton *)sender{
    [sender startCountDown];
}


@end
