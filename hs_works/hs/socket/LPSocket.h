//
//  LPSocket.h
//  ShaolinGPS
//
//  Created by Pengfei Shi on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define SOCKET_PORT  33333

#define SOCKET_IP  @"120.26.109.180"
//#define SOCKET_IP    @"121.40.85.43"

//#define SOCKET_PORT  13501
//#define SOCKET_IP    @"192.168.1.19"

#define SERVER_SIDE  'S'
#define CLIENT_SIDE  'E'

#define LOGIN_COMMAND                  0x01
#define LOGIN_RESPONSE_COMMAND         0x81
#define HEART_COMMAND                  0x80
#define HEART_RESPONDE_COMMAND         0x00

typedef int8_t       SPFInt8;
typedef int16_t      SPFInt16;
typedef int32_t      SPFInt32;
typedef u_int8_t     SPFUInt8;
typedef u_int16_t    SPFUInt16;
typedef u_int32_t    SPFUInt32;
typedef Byte         SPFByte;

#pragma pack(1)

typedef struct 
{
    SPFUInt16 packetLength;
    SPFUInt8  side;
    SPFUInt8  command;
    
} PacketHeader;

typedef struct
{
    PacketHeader header;
    
    SPFByte        version[8];
    SPFByte        identifier[11];
    
} LoginPacket;

typedef struct
{
    PacketHeader header;
    
    SPFByte        date[6];
    SPFUInt8       result;
    char*          errorMessage;
    
} LoginResponsePacket;


typedef struct
{
    PacketHeader header;
    
    SPFUInt16   timeInterval;
    
} HeartPacket;


/*
  age 1
 
  sex 1 
 
  height 2 
 
  motto 4
 */

typedef struct
{
    int8_t  age;
    
    int8_t sex;
    
    int16_t height;
    
    char* motto;
    
}thePeople;


#pragma options align=reset
