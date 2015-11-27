//
//  PhotoNetWork.h
//  photo
//
//  Created by 顾晓东 on 15/11/23.
//  Copyright © 2015年 Zhixuan Lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "extendMothods.h"
typedef void(^callBackDataBlock)(BOOL isSuss,id response,AFNetworkReachabilityStatus netWorkStatus);
@interface PhotoNetWork : NSObject
@property (strong , nonatomic) AFHTTPRequestOperationManager * manager;

+(instancetype)netWork;
-(void)getActiveDataFromUrlPath:(NSString*)urlPath and:(callBackDataBlock)callBack;
@end
