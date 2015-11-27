//
//  photo.m
//  photo
//
//  Created by gxd on 15/11/11.
//  Copyright © 2015年 Zhixuan Lai. All rights reserved.
//

#import "photo.h"
#import "ProgressHUD.h"

@implementation photo
+(id)setdataWithDict:(NSDictionary *)t_dict{
    return [[self alloc] initWithDict:t_dict];

}
-(instancetype)initWithDict:(NSDictionary * )dict{
    self = [super init];
    if (self) {
        

        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

@end
