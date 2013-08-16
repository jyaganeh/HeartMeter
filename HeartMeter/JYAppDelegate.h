//
//  JYAppDelegate.h
//  HeartMeter
//
//  Created by Josh Yaganeh on 8/15/13.
//  Copyright (c) 2013 Josh Yaganeh. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface JYAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSMenu *statusMenu;
@property (weak) IBOutlet NSMenuItem *heartsMenuItem;

@property (strong) NSStatusItem *statusItem;
@property (strong) NSTimer *timer;

@end
