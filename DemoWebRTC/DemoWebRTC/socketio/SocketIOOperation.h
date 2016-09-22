//
//  SocketIOOperation.hpp
//  SocketIOCpp_Demo
//
//  Created by zhangqi on 22/9/2016.
//  Copyright © 2016 MaxwellQi. All rights reserved.
//

#ifndef SocketIOOperation_hpp
#define SocketIOOperation_hpp

#include <stdio.h>
#include <functional>
#include <SocketIO-Client-CPP/sio_client.h>

class SocketIOOperation
{
public:
    SocketIOOperation();
    ~SocketIOOperation();
    int beginConnection(const char* url);
    int login(const char* username);
private:
    sio::client sclient;
    void onopen();
  
};

#endif /* SocketIOOperation_hpp */
