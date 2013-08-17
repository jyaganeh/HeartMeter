//
//  AppDelegate.h
//  HeartMeter
//
//  Created by Josh Yaganeh on 8/15/13.
//  Copyright (c) 2013 Josh Yaganeh. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PowerSourceInfoManager.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (weak) IBOutlet NSMenu *statusMenu;
@property (weak) IBOutlet NSMenuItem *menuItemStatus;
@property (weak) IBOutlet NSMenuItem *menuItemSource;

@property (strong) NSStatusItem *statusItem;
@property (strong) NSTimer *timer;
@property (strong) PowerSourceInfoManager* powerSourceInfoManager;

@end
