//
//  AppDelegate.m
//  HeartMeter
//
//  Created by Josh Yaganeh on 8/15/13.
//  Copyright (c) 2013 Josh Yaganeh. All rights reserved.
//

#import "AppDelegate.h"
#import <IOKit/ps/IOPSKeys.h>

/*
 _TODO_
 * Implement run at login functionality
 * Visually indicate charging/discharging?
 * Blink when low on hearts?
 * Add retina heart graphics
*/

#define STATUS_ITEM_LENGTH 84
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

/** Toggles whether or not HeartMeter will run automatically at login */
- (IBAction)toggleStartAtLogin:(id)sender {
    // TODO: Add/Remove item from autolaunch list
    NSMenuItem *item = (NSMenuItem *)sender;
    BOOL toggle = !(item.state == NSOnState);
    [item setState:(toggle ? NSOnState : NSOffState)];
}

/** Determine whether or not HeartMeter is currently set to run automatically at login */
- (BOOL)isStartAtLoginEnabled {
    // TODO: check to see if app is in autolaunch list
    return NO;
}

/** Updates the HeartMeter with the current PowerSourceInfo */
- (void)updateHeartMeter {
    PowerSourceInfo *powerSource = [self.powerSourceInfoManager getPowerSourceInfoWithIndex:0];
    
    [self updateStatusItemImageWithHearts:powerSource.percent];
    [self updateStatusTextWithPowerSource:powerSource];
    [self updateSourceTextWithPowerSource:powerSource];
}

/** Updates the status item image for the given battery percent */
- (void)updateStatusItemImageWithHearts:(int)percent {
    int roundedPercent = round(percent / 10) * 10;
    NSString *name = [NSString stringWithFormat:@"hearts_%d.png", roundedPercent];
    [self.statusItem setImage:[NSImage imageNamed:name]];
}

/** Updates the 'Status' Menu Item with the current time remaining */
-(void)updateStatusTextWithPowerSource:(PowerSourceInfo*)powerSource {
    NSString *title;
    if (powerSource.isMinutesRemainingProvided) {
        if (powerSource.minutesRemaining == -1) {
            title = @"Calculating Time Remaining...";
        } else if ([powerSource.type isEqual: @"AC Power"]
                   && powerSource.percent == 100
                   && !powerSource.isCharging) {
            title = @"Battery Is Charged";
        } else {
            int hours = powerSource.minutesRemaining / 60;
            int minutes = powerSource.minutesRemaining % 60;
            title = [NSString stringWithFormat:@"%d:%02d %@",
                     hours, minutes, (powerSource.isCharging ? @"Until Full" : @"Remaining")];
        }
    }
    [self.menuItemStatus setTitle:title];
}

/** Updates the 'Power Source' Menu Item with the current power source type */
-(void)updateSourceTextWithPowerSource:(PowerSourceInfo*)powerSource {
    NSString *title;
    if ([powerSource.type isEqualToString:@kIOPSBatteryPowerValue]) {
        title = @"Battery";
    } else if ([powerSource.type isEqualToString:@kIOPSACPowerValue]) {
        title = @"Power Adapter";
    } else {
        title = powerSource.type;
    }
    [self.menuItemSource setTitle:[NSString stringWithFormat:@"Power Source: %@", title]];
}

/** Rounds battery percentage to the nearest 0.5 */
-(float)heartsWithPercent:(int)percent
{
    float hearts = percent / 20.0;
    return round(hearts * 2.0) / 2.0;
}

@end
