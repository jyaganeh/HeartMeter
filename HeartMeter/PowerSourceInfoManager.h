//
// Created by Josh Yaganeh on 8/17/13.
// Copyright (c) 2013 Josh Yaganeh. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import <IOKit/ps/IOPowerSources.h>
#import "PowerSourceInfo.h"

@interface PowerSourceInfoManager : NSObject

- (PowerSourceInfo *)getPowerSourceInfoWithIndex:(int) index;

@end