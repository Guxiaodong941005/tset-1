//
//  IndexAndDirection.h
//  photo
//
//  Created by gxd on 15/10/30.
//  Copyright © 2015年 Zhixuan Lai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IndexAndDirection : NSObject
@property (strong , nonatomic) NSString * g_direction;
@property (assign , nonatomic) NSInteger g_index;
-(instancetype)init;
@end
