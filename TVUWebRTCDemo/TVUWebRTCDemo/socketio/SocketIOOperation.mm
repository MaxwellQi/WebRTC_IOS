//
//  SocketIOOperation.cpp
//  SocketIOCpp_Demo
//
//  Created by zhangqi on 22/9/2016.
//  Copyright © 2016 MaxwellQi. All rights reserved.
//

#include "SocketIOOperation.h"
#include <iostream>
using namespace std;
using namespace sio;
#include <string.h>

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
    std::string s("zhangqi-ios");
    sclient.socket()->emit("login", s);
    
}

void SocketIOOperation::callPhone()
{
    printf("call others\n");
    std::string s("borisyang-ios");
    sclient.socket()->emit("call_request",s);
    
}

void SocketIOOperation::postresponse_tvu()
{
    printf("response\n");
//    std::string s("zhangqi-ios");
    std::string s("borisyang-ios");
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
//    sclient.socket()->on("call_request", sio::socket::event_listener_aux([&](string const&name,
//                                                                             message::ptr const& data,bool isAck,message::list &ack_resp)
//                                                                         {
//                                                                             bool res = data->get_map()["success"]->get_bool();
//                                                                             
//                                                                             printf("socket.io---debug----call request result:%d",res);
//                                                                         }));
    
    
    
    // begin connect
    sclient.connect("http://10.12.23.232:9000");
    
    return 0;
}

int SocketIOOperation::login(const char * username)
{

    return 0;
}



