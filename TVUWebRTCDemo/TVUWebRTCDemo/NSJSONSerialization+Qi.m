//
//  NSJSONSerialization+Qi.m
//  TVUWebRTCDemo
//
//  Created by zhangqi on 10/10/2016.
//  Copyright © 2016 MaxwellQi. All rights reserved.
//

#import "NSJSONSerialization+Qi.h"

@implementation NSJSONSerialization (Qi)

+ (NSString *)JSONStringWithJSONObject:(id)obj
{
    if ([NSJSONSerialization isValidJSONObject:obj]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&error];
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return NULL;
}
@end
