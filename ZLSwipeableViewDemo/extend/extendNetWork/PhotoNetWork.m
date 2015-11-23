//
//  PhotoNetWork.m
//  photo
//
//  Created by 顾晓东 on 15/11/23.
//  Copyright © 2015年 Zhixuan Lai. All rights reserved.
//

#import "PhotoNetWork.h"
#define BASEURL @"http://52.32.62.9/"
@implementation PhotoNetWork
+(instancetype)netWork{
    return [[self alloc] init];
}
#pragma mark - main mothods
-(void)getActiveDataFromUrlPath:(NSString*)urlPath{
    NSString * t_url = @"风景.json";
    [_manager GET:t_url parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (!responseObject) {
                self.callBackDataBlock(YES,responseObject,_manager.reachabilityManager.networkReachabilityStatus);
        }else{
            self.callBackDataBlock(NO ,nil ,_manager.reachabilityManager.networkReachabilityStatus);
        }
        
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        self.callBackDataBlock(NO,nil,_manager.reachabilityManager.networkReachabilityStatus);
    }];



}
#pragma mark -getter mothods
-(AFHTTPRequestOperationManager *)manager{
    if (!_manager) {
        _manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:BASEURL]];
        _manager.responseSerializer = [[AFJSONResponseSerializer alloc] init];
    }
    return _manager;
}

@end
