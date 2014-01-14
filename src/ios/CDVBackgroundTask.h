#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Cordova/CDVPlugin.h>

@interface CDVBackgroundTaskData: NSObject

@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundTaskId;
@property (nonatomic, assign) NSString *callbackId;

@end


@interface CDVBackgroundTask : CDVPlugin

@property (nonatomic, assign) NSMutableDictionary *backgroundTasks;

- (void)startInBackground:(CDVInvokedUrlCommand*)command;
- (void)stopInBackground:(CDVInvokedUrlCommand*)command;

@end
