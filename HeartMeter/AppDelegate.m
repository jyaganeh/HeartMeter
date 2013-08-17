//
//  AppDelegate.m
//  HeartMeter
//
//  Created by Josh Yaganeh on 8/15/13.
//  Copyright (c) 2013 Josh Yaganeh. All rights reserved.
//

#import "AppDelegate.h"

/*
 _TODO_

 * Add battery time remaining to dropdown
 * Add option to start on login
 * Indicate charging/discharging
 * Blink when low on hearts?
 * Crop heart images and add retina versions
 * Reformat batteryPercent code so it's not copy-pasta
*/

#define STATUS_ITEM_LENGTH 94
#define ONE_MINUTE 60

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Initialize system status bar item
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:STATUS_ITEM_LENGTH];
    [self.statusItem setHighlightMode:NO];
    [self.statusItem setMenu:self.statusMenu];

    // Create an instance of the PowerSourceInfoManager
    self.powerSourceInfoManager = [PowerSourceInfoManager new];

    // Set a timer to periodically update the HeartMeter
    self.timer = [NSTimer timerWithTimeInterval:5*ONE_MINUTE
                                         target:self
                                       selector:@selector(updateHeartMeter)
                                       userInfo:nil
                                        repeats:YES];
    [self.timer fire];
}

/** Updates the HeartMeter with the current PowerSourceInfo */
-(void)updateHeartMeter
{
    PowerSourceInfo *powerSource = [self.powerSourceInfoManager getPowerSourceInfoWithIndex:0];
    
    [self updateStatusItemImageWithHearts:powerSource.percent];
    [self updateStatusTextWithPowerSource:powerSource];
    [self updateSourceTextWithPowerSource:powerSource];
}

/** Updates the status bar item image for the given battery percent */
-(void)updateStatusItemImageWithHearts:(int)percent {
    float numHearts = [self heartsWithPercent:percent];
    
    // Drop the decimal from the number of hearts to get the first part of the filename
    int n = (int)numHearts;
    // Determine whether or not to show a half heart to get the second part of the filename
    int m = (n == numHearts) ? 0 : 5;
    
    [self.statusItem setImage:[NSImage imageNamed:[NSString stringWithFormat:@"hearts_%d_%d.png", n, m]]];
}

/** Updates the 'Status' Menu Item with the current time remaining and battery percentage */
-(void)updateStatusTextWithPowerSource:(PowerSourceInfo*)powerSource {
    NSString *title = @"";
    if (powerSource.isMinutesRemainingProvided) {
        int hours = powerSource.minutesRemaining % 60;
        int minutes = powerSource.minutesRemaining - (powerSource.minutesRemaining % 60);
        title = [title stringByAppendingFormat:@"%d:%d Remaining ", hours, minutes];
    }
    title = [title stringByAppendingFormat:@"(%d%%)", powerSource.percent];
    [self.menuItemStatus setTitle:title];
}

/** Updates the 'Power Source' Menu Item with the current power source type */
-(void)updateSourceTextWithPowerSource:(PowerSourceInfo*)powerSource {
    [self.menuItemSource setTitle:[NSString stringWithFormat:@"Power Source: %@", powerSource.type]];
}

/** Rounds battery percentage to the nearest 0.5 */
-(float)heartsWithPercent:(int)percent
{
    float hearts = percent / 20.0;
    return round(hearts * 2.0) / 2.0;
}

@end
