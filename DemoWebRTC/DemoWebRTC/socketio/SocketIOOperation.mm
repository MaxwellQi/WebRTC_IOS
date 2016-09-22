//
//  SocketIOOperation.cpp
//  SocketIOCpp_Demo
//
//  Created by zhangqi on 22/9/2016.
//  Copyright © 2016 MaxwellQi. All rights reserved.
//

#include "SocketIOOperation.h"
using namespace std;
using namespace sio;
#include <string.h>


SocketIOOperation::SocketIOOperation()
{
}

SocketIOOperation::~SocketIOOperation()
{

}

void SocketIOOperation::onopen()
{
    printf("connect succ\n");
    std::string s("zhangqi-ios");
    sclient.socket()->emit("login", s);
    
}


int SocketIOOperation::beginConnection(const char *url)
{
    sclient.set_open_listener(std::bind(&SocketIOOperation::onopen, this));
    sclient.socket()->on("login", sio::socket::event_listener_aux([&](string const&name,
                                                                      message::ptr const& data,bool isAck,message::list &ack_resp)
                                                                  {
                                                                      bool res = data->get_map()["success"]->get_bool();
                                                                      
                                                                      printf("socket.io---debug----login result:%d",res);
                                                                  }));
    // bind other event
    
    
    // begin connect
    sclient.connect("http://10.12.23.232:9000");
    
    return 0;
}

int SocketIOOperation::login(const char * username)
{

    return 0;
}



