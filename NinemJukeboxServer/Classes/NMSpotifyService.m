//
//  NMSpotifyService.m
//  NinemJukeboxServer
//
//  Created by Jeff Forbes on 12/27/12.
//  Copyright (c) 2012 9MMedia. All rights reserved.
//

#import "NMSpotifyService.h"
#import "SpotifyCredentials.h"

@implementation NMSpotifyService

static NMSpotifyService* __sharedService = nil;

+ (id)sharedService
{
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    __sharedService = [[NMSpotifyService alloc] init];
    [__sharedService performSignIn];
  });
  return __sharedService;
}

- (id)init
{
  if( self = [super init] ){
    NSError *error = nil;
    [SPSession initializeSharedSessionWithApplicationKey:[NSData dataWithBytes:&g_appkey length:g_appkey_size]
                                               userAgent:@"com.spotify.SimplePlayer"
                                           loadingPolicy:SPAsyncLoadingManual
                                                   error:&error];
    if (error != nil) {
      NSLog(@"CocoaLibSpotify init failed: %@", error);
      abort();
    }
    [[SPSession sharedSession] setDelegate:self];
    self.playbackManager = [[SPPlaybackManager alloc] initWithPlaybackSession:[SPSession sharedSession]];
    [_playbackManager setDelegate:self];
    [_playbackManager addObserver:self forKeyPath:@"trackPosition" options:NSKeyValueObservingOptionNew context:nil];
    [_playbackManager addObserver:self forKeyPath:@"isPlaying" options:NSKeyValueObservingOptionNew context:nil];
  }
  return self;
}

- (void)performSignIn
{
  [[SPSession sharedSession] attemptLoginWithUserName:@"1261129421"
                                               password:@"spotifypassword"];
}

#pragma mark - 
#pragma mark SPSessionDelegate

-(void)sessionDidLoginSuccessfully:(SPSession *)aSession
{
  [self setServiceReadyForPlayback:YES];
}

-(void)sessionDidLogOut:(SPSession *)aSession
{
  [self setServiceReadyForPlayback:NO];
}

-(void)session:(SPSession *)aSession didLogMessage:(NSString *)aMessage
{
  NSLog(@"%@", aMessage);
}

-(void)sessionDidEndPlayback:(SPSession *)aSession {
  NSLog(@"ENDED");
  [[NSNotificationCenter defaultCenter] postNotificationName:@"PlaybackDidEnd" object:self];

}

-(void)playbackManagerWillStartPlayingAudio:(SPPlaybackManager *)aPlaybackManager
{
}

-(void)playbackManagerWillEndPlayingAudio:(SPPlaybackManager *)aPlaybackManager
{
  [[NSNotificationCenter defaultCenter] postNotificationName:@"PlaybackDidEnd" object:self];
}

- (void)playTrackWithURI:(NSString*)uri
{
  [[SPSession sharedSession] trackForURL:[NSURL URLWithString:uri] callback:^(SPTrack *track) {
    if (track != nil) {
      [SPAsyncLoading waitUntilLoaded:track timeout:kSPAsyncLoadingDefaultTimeout then:^(NSArray *tracks, NSArray *notLoadedTracks) {
        [self setCurrentlyPlayingTrack:track];
        [self.playbackManager playTrack:track callback:^(NSError *error) {
          NSLog(@"error: %@", error);
        }];
      }];
    }
  }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  if( [keyPath isEqualToString:@"trackPosition"] ){
    [self willChangeValueForKey:@"trackPercentage"];
    _trackPercentage = [_playbackManager trackPosition]/[_currentlyPlayingTrack duration];
    [self didChangeValueForKey:@"trackPercentage"];
  }
}

@end

