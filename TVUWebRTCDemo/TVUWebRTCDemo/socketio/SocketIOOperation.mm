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
#import <AppRTC/ARDAppClient.h>
#import <AppRTC/RTCSessionDescription+JSON.h>
#import "Const.h"
#import "NSJSONSerialization+Qi.h"
using namespace std;
using namespace sio;
#include <string.h>

string remoteSessionDes;

const char* getUserName();
SocketIOOperation::SocketIOOperation()
{

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
    return [[NSJSONSerialization JSONStringWithJSONObject:dict] UTF8String];
}

const char* getResponseParam()
{
    NSDictionary *dict = @{@"to":@"222222",@"response":@"true"};
    return [[NSJSONSerialization JSONStringWithJSONObject:dict] UTF8String];
}

void SocketIOOperation::postanswer(const char* sdp)
{
    std::string strsdp(sdp);
    NSDictionary *dict = @{@"to":@"222222",@"type":@"answer",@"sdp":[NSString stringWithUTF8String:sdp]};
    NSString *offer_json = [NSJSONSerialization JSONStringWithJSONObject:dict];
    if ([offer_json length] > 0) {
        string answerparam([offer_json UTF8String]);
        sclient.socket()->emit("answer",answerparam);
    }
}

void SocketIOOperation::postice(const char* candidate,const char* sdpMid,const char* sdpMLineIndex)
{
    NSDictionary *dict = @{@"to":@"222222",@"candidate":[NSString stringWithUTF8String:candidate],@"sdpMid":[NSString stringWithUTF8String:sdpMid],@"sdpMLineIndex":[NSString stringWithUTF8String:sdpMLineIndex]};
    
    NSString *offer_json = [NSJSONSerialization JSONStringWithJSONObject:dict];
    if ([offer_json length] > 0) {
        string iceparam([offer_json UTF8String]);
        sclient.socket()->emit("ice",iceparam);
    }
}

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
                                                                             // response
                                                                             string responseParam(getResponseParam());
                                                                             sclient.socket()->emit("call_response",responseParam);
                                                                             printf("sent call response\n");
                                                                         }));
    
    sclient.socket()->on("call_response", sio::socket::event_listener_aux([&](string const&name,
                                                                      message::ptr const& data,bool isAck,message::list &ack_resp)
                                                                  {
                                                                      printf("get call response\n");
                                                                      printf("%s",data->get_string().c_str());
                                                                  }));
    
    sclient.socket()->on("offer", sio::socket::event_listener_aux([&](string const&name,
                                                                      message::ptr const& data,bool isAck,message::list &ack_resp)
                                                                  {
                                                                      printf("------------offer begin----------\n");
                                                                      remoteSessionDes = data->get_string();
                                                                      printf("from %s\n",data->get_string().c_str());
                                                                      printf("------------offer end----------\n");
                                                                  }));
    sclient.socket()->on("ice", sio::socket::event_listener_aux([&](string const&name,
                                                                      message::ptr const& data,bool isAck,message::list &ack_resp)
                                                                  {
                                                                      printf("----------in ice-------------\n");
                                                                      printf("%s",data->get_string().c_str());
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



