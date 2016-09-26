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
#include <thread>
#include <SocketIO-Client-CPP/sio_client.h>

class SocketIOOperation
{
public:
    static SocketIOOperation * getInstance();
    SocketIOOperation();
    ~SocketIOOperation();
    int beginConnection(const char* url);
    int login(const char* username);
    void callPhone();
    void postresponse_tvu();
    
private:
    sio::client sclient;
    void onopen();
    void postResponse();
    static SocketIOOperation * m_instance;
    
//    static pthread_t m_postResponsethread;
//    static void * PostResponse(void *arg);
    
    
  
};

#endif /* SocketIOOperation_hpp */
