//
//  PhotoNetWork.m
//  photo
//
//  Created by 顾晓东 on 15/11/23.
//  Copyright © 2015年 Zhixuan Lai. All rights reserved.
//

#import "PhotoNetWork.h"
#define BASEURL @"http://52.32.62.9"
@implementation PhotoNetWork
+(instancetype)netWork{
    return [[self alloc] init];
}
#pragma mark - main mothods
-(void)getActiveDataFromUrlPath:(NSString*)urlPath and:(callBackDataBlock)callBack{
   
    [self.manager GET:urlPath parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if (responseObject) {
                callBack(YES,responseObject,_manager.reachabilityManager.networkReachabilityStatus);
        }else{
            callBack(NO ,nil ,_manager.reachabilityManager.networkReachabilityStatus);
        }
        
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        callBack(NO,nil,_manager.reachabilityManager.networkReachabilityStatus);
    }];



}
#pragma mark -getter mothods
-(AFHTTPRequestOperationManager *)manager{
    if (!_manager) {
        _manager = [[AFHTTPRequestOperationManager alloc] init];
        _manager.requestSerializer.timeoutInterval = 15.f;
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    return _manager;
}

@end
