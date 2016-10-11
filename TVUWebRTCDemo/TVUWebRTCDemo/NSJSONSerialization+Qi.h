//
//  NSJSONSerialization+Qi.h
//  TVUWebRTCDemo
//
//  Created by zhangqi on 10/10/2016.
//  Copyright © 2016 MaxwellQi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSJSONSerialization (Qi)

/**
 *  Get json string
 *
 *  @param obj Foundation object
 *
 *  @return json string
 */
+ (NSString *)JSONStringWithJSONObject:(id)obj;

/**
 *  Get json value though key .
 *
 *  @param key     json key
 *  @param jsonstr json string. The jsonstr must have the following properties:
            - jsonstr must be a simple json string
            - jsonstr's format like this: {"key","value"} . Only support this format.
 *
 *  @return json's value
 */
+ (NSString *)getJsonValueWithKey:(NSString *)key jsonString:(NSString *)jsonstr;
@end
