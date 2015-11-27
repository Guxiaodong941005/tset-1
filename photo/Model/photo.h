//
//  photo.h
//  photo
//
//  Created by gxd on 15/11/11.
//  Copyright © 2015年 Zhixuan Lai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IndexAndDirection.h"
@interface photo : NSObject
@property (strong , nonatomic) NSString * floor;
@property (strong , nonatomic) NSString * content;
@property (strong , nonatomic) NSString * imageurl;

+(id)setdataWithDict:(NSDictionary *)t_dict;
@end
