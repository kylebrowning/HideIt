//
//  DragWindow.m
//  HideIt
//
//  Created by Kyle Browning on 1/19/11.
//  Copyright 2011 Grasscove. All rights reserved.
//

#import "DragWindow.h"
#import "SecurityInterface/SFAuthorizationView.h"

@implementation DragWindow

- (id)initWithFrame:(NSRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code here.
  }
  [self registerForDraggedTypes:[NSArray arrayWithObject:NSURLPboardType]];
  return self;
}
- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender {
  NSPasteboard *pboard;
  NSDragOperation sourceDragMask;
  
  sourceDragMask = [sender draggingSourceOperationMask];
  pboard = [sender draggingPasteboard];
  
  if ( [[pboard types] containsObject:NSColorPboardType] ) {
    if (sourceDragMask & NSDragOperationGeneric) {
      return NSDragOperationGeneric;
    }
  }
  if ( [[pboard types] containsObject:NSFilenamesPboardType] ) {
    if (sourceDragMask & NSDragOperationLink) {
      return NSDragOperationCopy;
    } else if (sourceDragMask & NSDragOperationCopy) {
      return NSDragOperationCopy;
    }
  }
  return NSDragOperationNone;
}
- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender {
  AuthorizationRef myAuthorizationRef;
  OSStatus myStatus;
  myStatus = AuthorizationCreate (NULL, kAuthorizationEmptyEnvironment,
                                  kAuthorizationFlagDefaults, &myAuthorizationRef);
  AuthorizationItem myItems[1];
  
  myItems[0].name = "system.privilege.admin";
  myItems[0].valueLength = 0;
  myItems[0].value = NULL;
  myItems[0].flags = 0;
  
  AuthorizationRights myRights;
  myRights.count = sizeof (myItems) / sizeof (myItems[0]);
  myRights.items = myItems;
  AuthorizationFlags myFlags;
  myFlags = kAuthorizationFlagDefaults |
  kAuthorizationFlagInteractionAllowed |
  kAuthorizationFlagExtendRights;
  //myStatus = AuthorizationCopyRights (myAuthorizationRef, &myRights, kAuthorizationEmptyEnvironment, myFlags, NULL);
  NSPasteboard *pboard;
  NSDragOperation sourceDragMask;
  
  sourceDragMask = [sender draggingSourceOperationMask];
  pboard = [sender draggingPasteboard];
  
  if ( [[pboard types] containsObject:NSColorPboardType] ) {
    // Only a copy operation allowed so just copy the data
  } else if ( [[pboard types] containsObject:NSFilenamesPboardType] ) {
    NSArray *files = [pboard propertyListForType:NSFilenamesPboardType];
    
    // Depending on the dragging source and modifier keys,
    // the file data may be copied or linked
    if (sourceDragMask & NSDragOperationLink) {
      [self addLinkToFiles:files];
    } 
  }
  return YES;
}
- (void) addLinkToFiles:(NSArray*)array {
  NSString *fileName = [[array lastObject] stringByAppendingFormat:@"/Contents/Info.plist"];
//  NSMutableDictionary *plistToEdit = [NSMutableDictionary dictionaryWithContentsOfFile:fileName];
//  
//  [plistToEdit setObject:[NSNumber numberWithInt:0] forKey:@"LSUIElement"];
//  BOOL temp = [plistToEdit writeToFile:fileName atomically:YES];
//  NSLog(@"%@", [NSNumber numberWithBool:temp]);
//  NSLog(@"%@", plistToEdit);
  NSString* plistPath = nil;
  NSFileManager* manager = [NSFileManager defaultManager];
  if (plistPath = fileName) 
  {
    if ([manager isWritableFileAtPath:plistPath]) 
    {
      NSMutableDictionary* infoDict = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
      NSLog(@"%@",[[infoDict objectForKey:@"LSUIElement"] class] );
      if([[infoDict objectForKey:@"LSUIElement"] isEqualToNumber:[NSNumber numberWithBool:YES]]) {
        [infoDict setObject:[NSNumber numberWithBool:NO] forKey:@"LSUIElement"];
        NSLog(@"YES");
      } else {
        NSLog(@"NO");
        [infoDict setObject:[NSNumber numberWithBool:YES] forKey:@"LSUIElement"];
      }
      [infoDict writeToFile:plistPath atomically:NO];
    }
  }
}
- (void)drawRect:(NSRect)dirtyRect {
  // Drawing code here.
}

@end
