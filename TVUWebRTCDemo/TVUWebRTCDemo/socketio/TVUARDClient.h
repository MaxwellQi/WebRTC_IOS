//
//  TVUARDClient.h
//  TVUWebRTCDemo
//
//  Created by zhangqi on 28/9/2016.
//  Copyright © 2016 MaxwellQi. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <stdio.h>
#include <functional>
#include <thread>
#include <SocketIO-Client-CPP/sio_client.h>

@interface TVUARDClient : NSObject

- (void)listeningEvent;
@end
