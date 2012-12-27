//
//  NMSpotifyService.h
//  NinemJukeboxServer
//
//  Created by Jeff Forbes on 12/27/12.
//  Copyright (c) 2012 9MMedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaLibSpotify/CocoaLibSpotify.h>

@interface NMSpotifyService : NSObject<SPSessionDelegate, SPSessionPlaybackDelegate>

+ (id)sharedService;
- (void)playbackTrackWithURI:(NSString*)uri;

@property (retain) SPPlaybackManager* playbackManager;
@property (assign) BOOL serviceReadyForPlayback;
@end
