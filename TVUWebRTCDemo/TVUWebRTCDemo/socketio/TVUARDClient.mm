//
//  TVUARDClient.m
//  TVUWebRTCDemo
//
//  Created by zhangqi on 28/9/2016.
//  Copyright © 2016 MaxwellQi. All rights reserved.
//

#import "TVUARDClient.h"
#include <iostream>
#import <AppRTC/ARDAppClient.h>
#import <AppRTC/RTCSessionDescription+JSON.h>
#import "Const.h"
#import "NSJSONSerialization+Qi.h"
using namespace std;
using namespace sio;
#include <string.h>


extern std::string remoteSessionDes;

@interface TVUARDClient()
{
    sio::client m_socketClient;
}
@end

@implementation TVUARDClient


const char* getResponseParam()
{
    NSDictionary *dict = @{@"to":@"222222",@"response":@"true"};
    return [[NSJSONSerialization JSONStringWithJSONObject:dict] UTF8String];
}

- (void)listeningEvent
{
    m_socketClient.socket()->on("login", sio::socket::event_listener_aux([&](string const&name,
                                                                             message::ptr const& data,bool isAck,message::list &ack_resp)
                                                                         {
                                                                             bool res = data->get_map()["success"]->get_bool();
                                                                             printf("socket.io---debug----login result:%d\n",res);
                                                                         }));
    
    m_socketClient.socket()->on("call_request", sio::socket::event_listener_aux([&](string const&name,
                                                                             message::ptr const& data,bool isAck,message::list &ack_resp)
                                                                         {
                                                                             // response
                                                                             string responseParam(getResponseParam());
                                                                             m_socketClient.socket()->emit("call_response",responseParam);
                                                                             printf("sent call response\n");
                                                                         }));
    
    m_socketClient.socket()->on("call_response", sio::socket::event_listener_aux([&](string const&name,
                                                                              message::ptr const& data,bool isAck,message::list &ack_resp)
                                                                          {
                                                                              printf("get call response\n");
                                                                              printf("%s",data->get_string().c_str());
                                                                          }));
    
    m_socketClient.socket()->on("offer", sio::socket::event_listener_aux([&](string const&name,
                                                                      message::ptr const& data,bool isAck,message::list &ack_resp)
                                                                  {
                                                                      printf("------------offer begin----------\n");
                                                                      remoteSessionDes = data->get_string();
                                                                      printf("from %s\n",data->get_string().c_str());
                                                                      printf("------------offer end----------\n");
                                                                  }));
    
    m_socketClient.socket()->on("ice", sio::socket::event_listener_aux([&](string const&name,
                                                                    message::ptr const& data,bool isAck,message::list &ack_resp)
                                                                {
                                                                    printf("----------in ice-------------\n");
                                                                    printf("%s",data->get_string().c_str());
                                                                }));
    
    // begin connect
    m_socketClient.connect(WebRTCServer);
    
    
    
}
@end
