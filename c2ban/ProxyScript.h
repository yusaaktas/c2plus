#import <Foundation/Foundation.h>

@interface ProxyScript : NSObject

+ (NSString *)generateUUID;
+ (void)startMITMProxy;

@end
