//
//  NMPlaybackController.h
//  NinemJukeboxServer
//
//  Created by Jeff Forbes on 12/27/12.
//  Copyright (c) 2012 9MMedia. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NMSpotifyService.h"

@interface NMPlaybackController : NSViewController

@property (weak) IBOutlet NSView *imageContainer;
@property (weak) IBOutlet NSView *trackInfoContainer;
@property (weak) IBOutlet NSTextField *artistLabel;
@property (weak) IBOutlet NSTextField *trackLabel;
@property (weak) IBOutlet NSTextField *albumLabel;
@property (weak) IBOutlet NSTextField *nextLabel;
@property (weak) IBOutlet NSImageView *albumArtView;
@property (weak) IBOutlet NSProgressIndicator *songProgressIndicator;
@property (weak) IBOutlet NSTextField *songTimeElapsed;
@property (weak) IBOutlet NSTextField *songTimeRemaining;
@property (weak) IBOutlet NSProgressIndicator *downloadingProgressIndicator;
@property(nonatomic) int playlistIndex;

- (IBAction)nextTrackPressed:(id)sender;
- (void)setTrackListing:(NSArray*)tracks withCurrentTrackAtIndex:(int)idx;
@end
