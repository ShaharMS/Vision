#import <UIKit/UIKit.h>
#include "MetalWindow.hpp"

extern "C" const char* hxRunLibrary();

@interface VisionApp : UIResponder <UIApplicationDelegate>
@property(nonatomic, strong) UIWindow* window;
@end

@implementation VisionApp
- (BOOL)application:(UIApplication*)app didFinishLaunchingWithOptions:(NSDictionary*)options {
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.rootViewController = [UIViewController new];
    [self.window makeKeyAndVisible];
    dispatch_async(dispatch_get_main_queue(), ^{
        vision_metal::bindHostView(self.window.rootViewController.view);
        const char* error = hxRunLibrary();
        if (error) NSLog(@"VISION_METAL_FAIL %s", error);
        vision_metal::bindHostView(nil);
    });
    return YES;
}
@end

int main(int argc, char** argv) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass(VisionApp.class));
    }
}
