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

SocketIOOperation::SocketIOOperation()
{
    tvuLoginWebrtcStatus = false;
    tvucallfromnumber = "";
}

SocketIOOperation::~SocketIOOperation()
{

}

SocketIOOperation * SocketIOOperation::m_instance = NULL;
SocketIOOperation * SocketIOOperation::getInstance()
{
    if (m_instance == NULL) {
        m_instance = new SocketIOOperation();
    }
    return m_instance;
}

void SocketIOOperation::setTvuusernumber(std::string tvuusernumber)
{
    this->tvuusernumber = tvuusernumber;
}

std::string SocketIOOperation::getTvuusernumber()
{
    return this->tvuusernumber;
}

void SocketIOOperation::setTvucallfromnumber(std::string tvucallfromnumber)
{
    this->tvucallfromnumber = tvucallfromnumber;
}

std::string SocketIOOperation::getTvucallfromnumber()
{
    return this->tvucallfromnumber;
}

bool SocketIOOperation::isLoginTVUWebrtc()
{
    return this->tvuLoginWebrtcStatus;
}

void SocketIOOperation::setTvuIsAcceptCall(bool tvuIsAcceptCall)
{
    this->tvuIsAcceptCall = tvuIsAcceptCall;
}

bool SocketIOOperation::getTvuIsAcceptCall()
{
    return this->tvuIsAcceptCall;
}

void SocketIOOperation::onopen()
{
    printf("connect succ\n");
    NSString *usernumber = [NSString stringWithCString:this->getTvuusernumber().c_str() encoding:NSUTF8StringEncoding];
    NSDictionary *dict = @{@"username":usernumber};
    std::string requestparam_login([[NSJSONSerialization JSONStringWithJSONObject:dict] UTF8String]);
    sclient.socket()->emit("login",requestparam_login);
}

void SocketIOOperation::postanswer(const char* sdp)
{
    NSString *callfrom = [NSString stringWithUTF8String:tvucallfromnumber.c_str()];
    std::string strsdp(sdp);
    NSDictionary *dict = @{@"to":callfrom,@"type":@"answer",@"sdp":[NSString stringWithUTF8String:sdp]};
    NSString *offer_json = [NSJSONSerialization JSONStringWithJSONObject:dict];
    if ([offer_json length] > 0) {
        string answerparam([offer_json UTF8String]);
        sclient.socket()->emit("answer",answerparam);
    }
}

void SocketIOOperation::postice(const char* candidate,const char* sdpMid,const char* sdpMLineIndex)
{
    NSString *callfrom = [NSString stringWithUTF8String:tvucallfromnumber.c_str()];
    NSDictionary *dict = @{@"to":callfrom,@"candidate":[NSString stringWithUTF8String:candidate],@"sdpMid":[NSString stringWithUTF8String:sdpMid],@"sdpMLineIndex":[NSString stringWithUTF8String:sdpMLineIndex]};
    
    NSString *offer_json = [NSJSONSerialization JSONStringWithJSONObject:dict];
    if ([offer_json length] > 0) {
        string iceparam([offer_json UTF8String]);
        sclient.socket()->emit("ice",iceparam);
    }
}

void SocketIOOperation::postResponse(bool isAccept)
{
    NSString *response_value = isAccept ? @"true" : @"false";
    NSString *callfrom = [NSString stringWithUTF8String:tvucallfromnumber.c_str()];
    NSDictionary *dict = @{@"to":callfrom,@"response":response_value};
    string responseParam([[NSJSONSerialization JSONStringWithJSONObject:dict] UTF8String]);
    sclient.socket()->emit("call_response",responseParam);
    printf("get call request\n");

}

void SocketIOOperation::postCallRequest(std::string tvuusernumber)
{
    NSString *userid = [NSString stringWithUTF8String:tvuusernumber.c_str()];
    NSDictionary *dict = @{@"ids":@[userid]};
    string request_param([[NSJSONSerialization JSONStringWithJSONObject:dict] UTF8String]);
    sclient.socket()->emit("call_request",request_param);
}

void SocketIOOperation::postOffer(std::string offerParam)
{
    sclient.socket()->emit("offer",offerParam);
}

int SocketIOOperation::beginConnection(const char *url)
{
    sclient.set_open_listener(std::bind(&SocketIOOperation::onopen, this));
    sclient.socket()->on("login", sio::socket::event_listener_aux([&](string const&name,
                                                                      message::ptr const& data,bool isAck,message::list &ack_resp)
                                                                  {
                                                                      bool res = data->get_map()["success"]->get_bool();
                                                                     tvuLoginWebrtcStatus = res;
                                                                      printf("socket.io---debug----login result:%d\n",res);
                                                                  }));
    // bind other event
    sclient.socket()->on("call_request", sio::socket::event_listener_aux([&](string const&name,
                                                                             message::ptr const& data,bool isAck,message::list &ack_resp)
                                                                         {
                                                                             // response
                                                                             NSString *responseData = [NSString stringWithUTF8String:data->get_string().c_str()];
                                                                             NSString *callfrom = [NSJSONSerialization getJsonValueWithKey:@"from" jsonString:responseData];
                                                                             tvucallfromnumber = std::string([callfrom UTF8String]);
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



