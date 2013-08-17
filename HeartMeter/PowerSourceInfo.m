//
//  PowerSourceInfo.m
//  HeartMeter
//
//  Created by Josh Yaganeh on 8/17/13.
//  Copyright (c) 2013 Josh Yaganeh. All rights reserved.
//

#import "PowerSourceInfo.h"
#import <IOKit/ps/IOPSKeys.h>

// Add definition for kIOPSProvidesTimeRemaining (missing from IOPSKeys.h)
#define kIOPSProvidesTimeRemaining "Battery Provides Time Remaining"

@implementation PowerSourceInfo

-(id)initWithDictionary:(NSDictionary *)dictionary {
    if ((self = [super init]) && dictionary != nil) {
        info = (__bridge NSDictionary *) CFPropertyListCreateDeepCopy(kCFAllocatorDefault, (__bridge CFDictionaryRef)dictionary, 0);

        _isPresent = [info[@kIOPSIsPresentKey] boolValue];
        _isCharging = [info[@kIOPSIsChargingKey] boolValue];
        _isMinutesRemainingProvided = [info[@kIOPSProvidesTimeRemaining] boolValue];
        _currentCapacity = [info[@kIOPSCurrentCapacityKey] doubleValue];
        _maxCapacity = [info[@kIOPSMaxCapacityKey] doubleValue];
        _percent = (_currentCapacity / _maxCapacity) * 100;
        _minutesRemaining = (_isCharging ?
                [info[@kIOPSTimeToFullChargeKey] intValue] : [info[@kIOPSTimeToEmptyKey] intValue]);
        _type = [NSString stringWithFormat:@"%@", info[@kIOPSPowerSourceStateKey]];
    }
    return self;
}

@end
