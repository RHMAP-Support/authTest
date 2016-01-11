//
// Created by Willem Van Pelt on 19/11/15.
// Copyright (c) 2015 FeedHenry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (AppData)

+ (BOOL)deviceIsRegistered;

+ (NSString *)uid;

+ (BOOL)osVersionDidUpdate;

+ (BOOL)appVersionDidUpdate;

@end