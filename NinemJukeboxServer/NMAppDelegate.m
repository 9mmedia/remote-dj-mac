//
//  NMAppDelegate.m
//  NinemJukeboxServer
//
//  Created by Jeff Forbes on 12/27/12.
//  Copyright (c) 2012 9MMedia. All rights reserved.
//

#import "NMAppDelegate.h"
#import "NMPlaybackController.h"
#import "NMSpotifyService.h"

@implementation NMAppDelegate

-(void)applicationWillFinishLaunching:(NSNotification *)notification {
  [NMSpotifyService sharedService];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  


  [self setPlaybackController:[[NMPlaybackController alloc] initWithNibName:nil bundle:nil]];
  [[_window contentView] addSubview:[[self playbackController] view]];
  
	[self.window center];
	[self.window orderFront:nil];
  [self.window setBackgroundColor:[NSColor blackColor]];
  [[NSApplication sharedApplication] setPresentationOptions:NSApplicationPresentationFullScreen];
  
}



@end
