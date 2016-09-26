//
//  SocketIOOperation.cpp
//  SocketIOCpp_Demo
//
//  Created by zhangqi on 22/9/2016.
//  Copyright © 2016 MaxwellQi. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "SocketIOOperation.h"
#include <iostream>
using namespace std;
using namespace sio;
#include <string.h>

#define WebRTCServer "http://10.12.23.232:9000"

int socketioStatus;

const char* getUserName();
SocketIOOperation::SocketIOOperation()
{
    socketioStatus = 0;
}

SocketIOOperation::~SocketIOOperation()
{

}

SocketIOOperation * SocketIOOperation::getInstance()
{
    if (m_instance == NULL) {
        m_instance = new SocketIOOperation();
    }
    return m_instance;
}

void SocketIOOperation::onopen()
{
    printf("connect succ\n");
    std::string username(getUserName());
    printf("qizhang---debug---login params---%s",username.c_str());
    sclient.socket()->emit("login",username);
}

const char* getUserName()
{
    NSDictionary *dict = @{@"username":@"111111"};
    if ([NSJSONSerialization isValidJSONObject:dict]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
        NSString *username_json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return [username_json UTF8String];
    }
    return NULL;
}

const char* getResponseParam()
{
    NSDictionary *dict = @{@"to":@"111111",@"response":@"true"};
    if ([NSJSONSerialization isValidJSONObject:dict]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
        NSString *username_json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return [username_json UTF8String];
    }
    return NULL;
}

void SocketIOOperation::callPhone()
{
    printf("call others\n");
//    std::string s("222222");
    
    
}

void SocketIOOperation::postresponse_tvu()
{
    printf("response\n");
//    std::string s("zhangqi-ios");
    std::string s("222222");
    sclient.socket()->emit("call_response",s);
}

//static int i = 0;
//void * SocketIOOperation::PostResponse(void *arg)
//{
//    i++;
//    if(i < 10) return NULL;
//    i= 0;
//    std::string s("zhangqi-ios");
//    getInstance()->sclient.socket()->emit("call_response",s);
//    return NULL;
//}


int SocketIOOperation::beginConnection(const char *url)
{
    sclient.set_open_listener(std::bind(&SocketIOOperation::onopen, this));
    sclient.socket()->on("login", sio::socket::event_listener_aux([&](string const&name,
                                                                      message::ptr const& data,bool isAck,message::list &ack_resp)
                                                                  {
                                                                      bool res = data->get_map()["success"]->get_bool();
                                                                      
                                                                      printf("socket.io---debug----login result:%d\n",res);
                                                                      

                                                                  }));
    // bind other event
    sclient.socket()->on("call_request", sio::socket::event_listener_aux([&](string const&name,
                                                                             message::ptr const& data,bool isAck,message::list &ack_resp)
                                                                         {
                                                                             printf("get call request\n");
//                                                                             bool res = data->get_map()["success"]->get_bool();
//                                                                             
//                                                                             printf("socket.io---debug----call request result:%d",res);
                                                                             
                                                                             // response
                                                                             string responseParam(getResponseParam());
                                                                             sclient.socket()->emit("call_response",responseParam);
                                                                             printf("sent call response\n");
                                                                             
                                                                         }));
    
    
    
    sclient.socket()->on("call_response", sio::socket::event_listener_aux([&](string const&name,
                                                                      message::ptr const& data,bool isAck,message::list &ack_resp)
                                                                  {
                                                                      printf("get call response\n");
//                                                                      bool res = data->get_map()["success"]->get_bool();
//                                                                      
//                                                                      printf("socket.io---debug----call response result:%d\n",res);
                                                                      socketioStatus = 1;
                                                                      
                                                                  }));
    
    
    
    // begin connect
    sclient.connect(WebRTCServer);
    
    return 0;
}


int SocketIOOperation::login(const char* username)
{
    string name(username);
    sclient.socket()->emit("call_request",name);
    return 0;
}



