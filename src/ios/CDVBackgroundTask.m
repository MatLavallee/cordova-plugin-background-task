#import "CDVBackgroundTask.h"

@implementation CDVBackgroundTaskData

@synthesize backgroundTaskId = _backgroundTaskId, callbackId = _callbackId;

- (CDVBackgroundTaskData*)initWithBackgroundTaskId:(UIBackgroundTaskIdentifier)backgroundTaskId
                                    withCallbackId:(NSString*)callbackId
{
  if (self = [super init]) {
    _backgroundTaskId = backgroundTaskId;
    _callbackId = callbackId;
  }
  return self;
}

@end


@implementation CDVBackgroundTask

@synthesize backgroundTasks = _backgroundTasks;

- (CDVPlugin*)initWithWebView:(UIWebView *)theWebView
{
  self = (CDVBackgroundTask*)[super initWithWebView:(UIWebView*)theWebView];
  if(self) {
    self.backgroundTasks = [NSMutableDictionary dictionaryWithCapacity:1];
  }
  return self;
}

- (void)startInBackground:(CDVInvokedUrlCommand*)command
{
  NSString* callbackId = command.callbackId;
  NSString* taskId = [command.arguments objectAtIndex:0];

  UIBackgroundTaskIdentifier backgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithName:taskId expirationHandler:^{
    NSLog(@"Background Task %@ is expiring.", taskId);
  }];

  CDVBackgroundTaskData* data = [[CDVBackgroundTaskData alloc] initWithBackgroundTaskId:backgroundTaskId
                                                                         withCallbackId:callbackId];
  [_backgroundTasks setObject:data forKey:taskId];

  CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)stopInBackground:(CDVInvokedUrlCommand*)command
{
  NSString* taskId = [command.arguments objectAtIndex:0];

  CDVBackgroundTaskData *data = [_backgroundTasks valueForKey:taskId];
  [[UIApplication sharedApplication] endBackgroundTask:data.backgroundTaskId];

  [_backgroundTasks removeObjectForKey:taskId];

  CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
