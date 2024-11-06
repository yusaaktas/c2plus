#import <Foundation/Foundation.h>
#import "ProxyScript.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        [ProxyScript startMITMProxy];
        [[NSRunLoop currentRunLoop] run];
    }
    return 0;
}
