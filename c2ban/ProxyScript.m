{\rtf1\ansi\ansicpg1254\cocoartf2818
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 #import "ProxyScript.h"\
#import <objc/runtime.h>\
#import <CommonCrypto/CommonDigest.h>\
#import <GCDWebServer/GCDWebServer.h>\
#import <GCDWebServer/GCDWebServerDataResponse.h>\
\
@implementation ProxyScript\
\
+ (NSString *)generateUUID \{\
    return [[NSUUID UUID] UUIDString];\
\}\
\
+ (void)startMITMProxy \{\
    GCDWebServer* webServer = [[GCDWebServer alloc] init];\
    \
    [webServer addDefaultHandlerForMethod:@"GET"\
                              requestClass:[GCDWebServerRequest class]\
                              processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) \{\
        \
        NSMutableDictionary* queryParams = [request.query mutableCopy];\
        queryParams[@"device_id"] = [self generateUUID];\
        \
        NSLog(@"New device_id set: %@", queryParams[@"device_id"]);\
        \
        return [GCDWebServerDataResponse responseWithJSONObject:queryParams];\
    \}];\
    \
    [webServer startWithPort:8080 bonjourName:nil];\
    \
    NSLog(@"MITM proxy is running on port 8080");\
\}\
\
@end\
}