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
@end
