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
  NSRect frame = [[_window contentView] frame];
  NSRect newFrame = {0,0, frame.size.width, frame.size.height};
  [[[self playbackController] view] setFrame:newFrame];
  
  [NSThread detachNewThreadSelector:@selector(reloadLoop) toTarget:self withObject:nil];
  
	[self.window center];
	[self.window orderFront:nil];
  [self.window setBackgroundColor:[NSColor blackColor]];
  [[NSApplication sharedApplication] setPresentationOptions:NSApplicationPresentationFullScreen];
  
}

- (void)reloadLoop
{

  while(true){
    @autoreleasepool {
      NSMutableString* url = [NSMutableString stringWithString:@"http://localhost:3000/current_playlist"];
      if( [_playbackController playlistIndex] != -1 ){
        [url appendFormat:@"?current_index=%d",[_playbackController playlistIndex]];
      }
      NSData* playlistData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
      NSDictionary* playlist = [NSJSONSerialization JSONObjectWithData:playlistData options:NSJSONReadingAllowFragments error:nil];
      NSArray* tracks = [playlist objectForKey:@"tracks"];
      dispatch_async(dispatch_get_main_queue(), ^{
        [_playbackController setTrackListing:tracks withCurrentTrackAtIndex:[playlist[@"current_track_index"] intValue]];
      });
      sleep(5);
    }
  }
}

@end
