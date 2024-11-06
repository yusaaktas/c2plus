#import "ProxyScript.h"
#import <objc/runtime.h>
#import <CommonCrypto/CommonDigest.h>
#import <GCDWebServer/GCDWebServer.h>
#import <GCDWebServer/GCDWebServerDataResponse.h>

@implementation ProxyScript

+ (NSString *)generateUUID {
    return [[NSUUID UUID] UUIDString];
}

+ (void)startMITMProxy {
    GCDWebServer* webServer = [[GCDWebServer alloc] init];
    
    [webServer addDefaultHandlerForMethod:@"GET"
                              requestClass:[GCDWebServerRequest class]
                              processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
        
        NSMutableDictionary* queryParams = [request.query mutableCopy];
        queryParams[@"device_id"] = [self generateUUID];
        
        NSLog(@"New device_id set: %@", queryParams[@"device_id"]);
        
        return [GCDWebServerDataResponse responseWithJSONObject:queryParams];
    }];
    
    [webServer startWithPort:8080 bonjourName:nil];
    
    NSLog(@"MITM proxy is running on port 8080");
}

@end
