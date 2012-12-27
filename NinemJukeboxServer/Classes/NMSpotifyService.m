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
    [[SPSession sharedSession] setPlaybackDelegate:self];
    self.playbackManager = [[SPPlaybackManager alloc] initWithPlaybackSession:[SPSession sharedSession]];
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

-(void)sessionDidEndPlayback:(id <SPSessionPlaybackProvider>)aSession
{
  
}

-(void)session:(id <SPSessionPlaybackProvider>)aSession didEncounterStreamingError:(NSError *)error
{
}

-(void)sessionDidLosePlayToken:(id <SPSessionPlaybackProvider>)aSession
{
}

- (void)playbackTrackWithURI:(NSString*)uri
{
  
}

@end

