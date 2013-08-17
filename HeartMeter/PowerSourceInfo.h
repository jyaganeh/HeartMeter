//
//  PowerSourceInfo.h
//  HeartMeter
//
//  Created by Josh Yaganeh on 8/17/13.
//  Copyright (c) 2013 Josh Yaganeh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PowerSourceInfo : NSObject {
    NSDictionary *info;
}

@property (readonly, nonatomic) BOOL isPresent;
@property (readonly, nonatomic) BOOL isCharging;
@property (readonly, nonatomic) BOOL isConnected;
@property (readonly, nonatomic) BOOL isMinutesRemainingProvided;
@property (readonly, nonatomic) double currentCapacity;
@property (readonly, nonatomic) double maxCapacity;
@property (readonly, nonatomic) int percent;
@property (readonly, nonatomic) int minutesRemaining;
@property (readonly, nonatomic) NSString *type;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
