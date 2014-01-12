/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

#import "CDVRunningApps.h"

@implementation CDVRunningApps

- (void)getRunningApps:(CDVInvokedUrlCommand*)command
{
  NSArray *runningApps = [self getRunningAppsList];
  CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:runningApps];
  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (NSArray*)getRunningAppsList
{
  int mib[4] = {CTL_KERN, KERN_PROC, KERN_PROC_ALL, 0};
  size_t miblen = 4;

  size_t size;
  int st = sysctl(mib, miblen, NULL, &size, NULL, 0);

  struct kinfo_proc * process = NULL;
  struct kinfo_proc * newprocess = NULL;

  do {

    size += size / 10;
    newprocess = realloc(process, size);

    if (!newprocess){

      if (process){
        free(process);
      }

      return nil;
    }

    process = newprocess;
    st = sysctl(mib, miblen, process, &size, NULL, 0);

  } while (st == -1 && errno == ENOMEM);

  if (st == 0){

    if (size % sizeof(struct kinfo_proc) == 0){
      int nprocess = size / sizeof(struct kinfo_proc);

      if (nprocess){

        NSMutableArray * array = [[NSMutableArray alloc] init];

        for (int i = nprocess - 1; i >= 0; i--){
          bool isProcessRunning = process[i].kp_proc.p_flag == 18432;
          if(!isProcessRunning) continue;

          NSString * processName = [[NSString alloc] initWithFormat:@"%s", process[i].kp_proc.p_comm];
          [array addObject:processName];
        }

        free(process);
        return array;
      }
    }
  }

  return nil;
}
@end
