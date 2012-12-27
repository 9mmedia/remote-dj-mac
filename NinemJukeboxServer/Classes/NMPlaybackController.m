//
//  NMPlaybackController.m
//  NinemJukeboxServer
//
//  Created by Jeff Forbes on 12/27/12.
//  Copyright (c) 2012 9MMedia. All rights reserved.
//

#import "NMPlaybackController.h"

@interface NMPlaybackController ()

@end

@implementation NMPlaybackController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
      [[NMSpotifyService sharedService] addObserver:self forKeyPath:@"serviceReadyForPlayback" options:NSKeyValueObservingOptionNew context:nil];
    }
    
    return self;
}

- (void)playNextTrack
{
  [[NMSpotifyService sharedService] playTrackWithURI:@"http://open.spotify.com/track/5yEPxDjbbzUzyauGtnmVEC"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  if( object == [NMSpotifyService sharedService] ){
    if( [keyPath isEqualToString:@"serviceReadyForPlayback"] ){
      [self playNextTrack];
    }
  }
}


@end
