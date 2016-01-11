//
// Created by Willem Van Pelt on 19/11/15.
// Copyright (c) 2015 FeedHenry. All rights reserved.
//

#import "NSUserDefaults+AppData.h"


@implementation NSUserDefaults (AppData)

+ (BOOL)deviceIsRegistered {
    return [self uid] != nil;
}

+ (NSString *)uid {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
}

+ (BOOL)osVersionDidUpdate {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"lastKnownOsVersion"] != [[UIDevice currentDevice] systemVersion];
}

+ (BOOL)appVersionDidUpdate {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"lastKnownAppVersion"] != [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
}
@end