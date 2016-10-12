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
    void postanswer(const char* sdp);
    void postice(const char* candidate,const char* sdpMid,const char* sdpMLineIndex);
    void postResponse(bool isAccept);
    void postCallRequest(std::string tvuusernumber);
    void postOffer(std::string offerParam);
    
    void setTvuusernumber(std::string tvuusernumber);
    std::string getTvuusernumber();
    bool isLoginTVUWebrtc();
    void setTvucallfromnumber(std::string tvucallfromnumber);
    std::string getTvucallfromnumber();
    void setTvuIsAcceptCall(bool tvuIsAcceptCall);
    bool getTvuIsAcceptCall();
    
private:
    sio::client sclient;
    void onopen();
    static SocketIOOperation * m_instance;
    std::string tvuusernumber;
    std::string tvucallfromnumber;
    bool tvuLoginWebrtcStatus;
    bool tvuIsAcceptCall;
};

#endif /* SocketIOOperation_hpp */
