//
// Created by Josh Yaganeh on 8/17/13.
// Copyright (c) 2013 Josh Yaganeh. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "PowerSourceInfoManager.h"

@implementation PowerSourceInfoManager {

}
- (PowerSourceInfo *)getPowerSourceInfoWithIndex:(int)index {
    PowerSourceInfo *powerSourceInfo = nil;

    CFTypeRef info = IOPSCopyPowerSourcesInfo();
    if (info == NULL) {
        return nil;
    }

    CFArrayRef powerSources = IOPSCopyPowerSourcesList(info);
    if (CFArrayGetCount(powerSources) == 0) {
        return nil;
    }

    CFDictionaryRef source = IOPSGetPowerSourceDescription(info, CFArrayGetValueAtIndex(powerSources, index));

    powerSourceInfo = [[PowerSourceInfo alloc] initWithDictionary:(__bridge NSDictionary *)source];

    CFRelease(powerSources);
    CFRelease(info);

    return powerSourceInfo;
}

@end