//
//  NMAppDelegate.h
//  NinemJukeboxServer
//
//  Created by Jeff Forbes on 12/27/12.
//  Copyright (c) 2012 9MMedia. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CocoaLibSpotify/CocoaLibSpotify.h>
#import "NMPlaybackController.h"



@interface NMAppDelegate : NSObject <NSApplicationDelegate, SPSessionDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (retain) NMPlaybackController* playbackController;
@end
