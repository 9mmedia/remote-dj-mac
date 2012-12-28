//
//  NMPlaybackController.m
//  NinemJukeboxServer
//
//  Created by Jeff Forbes on 12/27/12.
//  Copyright (c) 2012 9MMedia. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
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
      [[NMSpotifyService sharedService] addObserver:self forKeyPath:@"currentlyPlayingTrack" options:NSKeyValueObservingOptionNew context:nil];
      [[NMSpotifyService sharedService] addObserver:self forKeyPath:@"trackPercentage" options:NSKeyValueObservingOptionNew context:nil];
    }
    
    return self;
}

- (void)playNextTrack
{
  [[NMSpotifyService sharedService] playTrackWithURI:@"spotify:track:7CPQtX37cGfY9mhmdwy9EK"];
  [[_albumArtView layer] setOpacity:0];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  if( object == [NMSpotifyService sharedService] ){
    if( [keyPath isEqualToString:@"serviceReadyForPlayback"] ){
      [self playNextTrack];
    }
    else if( [keyPath isEqualToString:@"currentlyPlayingTrack"] ){
      SPTrack* track = [[NMSpotifyService sharedService] currentlyPlayingTrack];
      [self updateDisplayWithTrack:track];
    }
    else if( [keyPath isEqualToString:@"trackPercentage"] ){
      double trackPercentage = [[NMSpotifyService sharedService] trackPercentage];
      double trackLength = [[[NMSpotifyService sharedService] currentlyPlayingTrack] duration];
      [_songProgressIndicator setDoubleValue:[[NMSpotifyService sharedService] trackPercentage]*100];
      double currentTime = trackLength*trackPercentage;
      int elapsedMinutes = currentTime/60;
      int elapsedSeconds = (int)currentTime%60;
      double remainingTime = trackLength-currentTime;
      int remainingMinutes = remainingTime/60;
      int remainingSeconds = (int)remainingTime%60;
      [_songTimeElapsed setStringValue:[NSString stringWithFormat:@"%d:%02d", elapsedMinutes, elapsedSeconds]];
      [_songTimeRemaining setStringValue:[NSString stringWithFormat:@"-%d:%02d", remainingMinutes, remainingSeconds]];
    }
  }
}

- (void)updateDisplayWithTrack:(SPTrack*)track
{
  [_artistLabel setStringValue:[[track artists][0] name]];
  [_trackLabel setStringValue:[track name]];
  [_albumLabel setStringValue:[[track album] name]];
  [self fetchAlbumArtForCurrentTrack:track];
}

- (void)fetchAlbumArtForCurrentTrack:(SPTrack*)track
{
  CABasicAnimation* theAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
  theAnimation.duration=1.0;
  theAnimation.repeatCount=0;
  theAnimation.fromValue=[NSNumber numberWithFloat:1.0];
  theAnimation.toValue=[NSNumber numberWithFloat:0.0];
  [[_albumArtView layer] addAnimation:theAnimation forKey:@"animateOpacity"];
  [[_albumArtView layer] setOpacity:0.0];
  
  [_downloadingProgressIndicator startAnimation:nil];
  //fixme: get off urlwithstring
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSString* urlString = [NSString stringWithFormat:@"http://localhost:3000/album_art?uri=%@", [[track album] spotifyURL]];
    NSData* urlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
    if( urlData ){
      urlString = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
      if( urlString ){
        urlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
        if( urlData ){
          NSImage* img = [[NSImage alloc] initWithData:urlData];
          dispatch_async(dispatch_get_main_queue(), ^{
            if( [[NMSpotifyService sharedService] currentlyPlayingTrack] == track ){
              [_albumArtView setImage:img];
              CABasicAnimation* theAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
              theAnimation.duration=1.0;
              theAnimation.repeatCount=0;
              theAnimation.fromValue=[NSNumber numberWithFloat:0.0];
              theAnimation.toValue=[NSNumber numberWithFloat:1.0];
              [[_albumArtView layer] addAnimation:theAnimation forKey:@"animateOpacity"];
              [[_albumArtView layer] setOpacity:1.0];
              [_downloadingProgressIndicator stopAnimation:nil];
            }
          });
        }
      }
    }
  });

}


@end
