//
//  JYAppDelegate.m
//  HeartMeter
//
//  Created by Josh Yaganeh on 8/15/13.
//  Copyright (c) 2013 Josh Yaganeh. All rights reserved.
//

#import "JYAppDelegate.h"
#include <CoreFoundation/CoreFoundation.h>
#include <IOKit/ps/IOPowerSources.h>
#include <IOKit/ps/IOPSKeys.h>

/*
 _TODO_

 * Make timer work
 * Add battery time remaining to dropdown
 * Add option to start on login
 * Indicate charging/discharging
 * Blink when low on hearts?
 * Crop heart images and add retina versions
 * Reformat batteryPercent code so it's not copy-pasta
*/

#define STATUS_ITEM_LENGTH 94
#define ONE_MINUTE 60

@implementation JYAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:STATUS_ITEM_LENGTH];
    [self.statusItem setHighlightMode:NO];
    [self.statusItem setMenu:self.statusMenu];
    
    [self updateHeartMeter];
    self.timer = [NSTimer timerWithTimeInterval:5*ONE_MINUTE
                                         target:self
                                       selector:@selector(updateHeartMeter)
                                       userInfo:nil
                                        repeats:YES];
}

-(void)updateHeartMeter
{
    float numHearts = [self heartsWithPercent:[self batteryPercent]];
    
    int n = (int)numHearts;
    int m = (n == numHearts) ? 0 : 5;
    NSString *imageName = [NSString stringWithFormat:@"hearts_%d_%d.png", n, m];
    
    [self.statusItem setImage:[NSImage imageNamed:imageName]];
    [self.heartsMenuItem setTitle:[NSString stringWithFormat:@"Hearts: %0.1f", numHearts]];
    
    NSLog(@"Battery Percent: %d, Hearts: %0.1f", [self batteryPercent],numHearts);
}

-(float)heartsWithPercent:(int)percent
{
    return (percent / 10) / 2.0;
}

// Source: http://forums.macrumors.com/showpost.php?p=5352544&postcount=2
-(int)batteryPercent
{
	CFTypeRef blob = IOPSCopyPowerSourcesInfo();
	CFArrayRef sources = IOPSCopyPowerSourcesList(blob);
	
	CFDictionaryRef pSource = NULL;
	const void *psValue;
	
	int numOfSources = (int)CFArrayGetCount(sources);
	if (numOfSources == 0) return 1;
	
	if (numOfSources == 1) {
        pSource = IOPSGetPowerSourceDescription(blob, CFArrayGetValueAtIndex(sources, 0));
		if (!pSource) return 2;
		
		psValue = (CFStringRef)CFDictionaryGetValue(pSource, CFSTR(kIOPSNameKey));
		
		int curCapacity = 0;
		int maxCapacity = 0;
		int percent;
		
		psValue = CFDictionaryGetValue(pSource, CFSTR(kIOPSCurrentCapacityKey));
		CFNumberGetValue((CFNumberRef)psValue, kCFNumberSInt32Type, &curCapacity);
		
		psValue = CFDictionaryGetValue(pSource, CFSTR(kIOPSMaxCapacityKey));
		CFNumberGetValue((CFNumberRef)psValue, kCFNumberSInt32Type, &maxCapacity);
		
		percent = (int)((double)curCapacity/(double)maxCapacity * 100);
		
		printf ("percent: %d/%d %d\n", curCapacity, maxCapacity, percent);
        return percent;
    }
	
    return 0;
}
@end
