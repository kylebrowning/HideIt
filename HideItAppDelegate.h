//
//  HideItAppDelegate.h
//  HideIt
//
//  Created by Kyle Browning on 1/19/11.
//  Copyright 2011 Grasscove. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface HideItAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
