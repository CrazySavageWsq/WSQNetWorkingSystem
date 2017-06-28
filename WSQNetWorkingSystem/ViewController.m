//
//  ViewController.m
//  WSQNetWorkingSystem
//
//  Created by webapps on 16/12/28.
//  Copyright © 2016年 webapps. All rights reserved.
//

#import "ViewController.h"
#import "WsqflyNetSession.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//[[WsqflyNetWorking wsqflyNetWorkingShare]get1:@"http://www.baidu.com"];
    
//    [[WsqflyNetWorking wsqflyNetWorkingShare]post:@"http://120.76.55.206/api/auth/login" Bodyparam:@{@"mobile_phone":@"18378312257",@"password":@"123654"}];
    
//    [[WsqflyNetWorking wsqflyNetWorkingShare] post:@"http://suiyongbao.com.cn/api/auth/login" bodyparam:@{@"mobile_phone":@"18378312257",@"password":@"123654"} success:^(id response) {
//        NSLog(@"successBlockback：%@",response);
//    } requestHead:^(id response) {
//        
//    } faile:^(NSError *error) {
//        
//    }];
    
    
    NSLog(@"测试是自己");
    
    self.view.backgroundColor= [UIColor yellowColor];
    
    [[WsqflyNetSession wsqflyNetWorkingShare] post:@"http://suiyongbao.com.cn/api/auth/login" bodyparam:@{@"mobile_phone":@"18378312257",@"password":@"123654"} maskState:WsqflyNetSessionMaskStateNotTouch backData:WsqflyNetSessionResponseTypeJSON success:^(id response) {
         NSLog(@"successBlockback：%@",response);
    } requestHead:^(id response) {
        
    } faile:^(NSError *error) {
        
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
