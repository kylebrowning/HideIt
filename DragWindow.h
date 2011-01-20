//
//  DragWindow.h
//  HideIt
//
//  Created by Kyle Browning on 1/19/11.
//  Copyright 2011 Grasscove. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface DragWindow : NSView {
  NSString *filePath;
  IBOutlet NSButton *hideItButton;
  IBOutlet NSTextField *textFieldLabel;
}
- (void) changePlist;
- (IBAction) buttonPressed:(id)sender;
@end
