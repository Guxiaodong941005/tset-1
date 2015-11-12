//
//  extendMothods.h
//  photo
//
//  Created by gxd on 15/11/12.
//  Copyright © 2015年 Zhixuan Lai. All rights reserved.
//

#import <Foundation/Foundation.h>
//// 是什么类型的对象
typedef NS_ENUM(NSUInteger, WhichKind) {
    
    isBOOL,
 
    isNSString,
  
    isNSArray,
   
    isNSDictionary
};
/**
 * 判断是否是第一次加载MainView
 *
 *  @return 是否是第一次
 */
////判断是否是第一次加载MainView
static inline BOOL judgeIsFirstLoadMainView(){
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"IsFirstLoadMainView"];

}

//// 保存本地信息
static inline void setNSUserDefaults(NSString * t_key , WhichKind kind ,id object){
    switch (kind) {
        case isBOOL:
            if ([(NSString *)object isEqualToString:@"1"]) {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:t_key];
            }else{
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:t_key];
            }
      
            break;
        case isNSString:
            [[NSUserDefaults standardUserDefaults] setObject:(NSString *)object forKey:t_key];
            break;
        case isNSArray:
            [[NSUserDefaults standardUserDefaults] setObject:(NSArray *)object forKey:t_key];
            break;
        case isNSDictionary:
            [[NSUserDefaults standardUserDefaults] setObject:(NSDictionary *)object forKey:t_key];
        default:
            break;
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
}
@interface extendMothods : NSObject

@end
