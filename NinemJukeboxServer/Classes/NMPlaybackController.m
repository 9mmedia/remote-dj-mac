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
      [[NMSpotifyService sharedService] addObserver:self forKeyPath:@"currentlyPlayingTrack" options:NSKeyValueObservingOptionNew context:nil];
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
    else if( [keyPath isEqualToString:@"currentlyPlayingTrack"] ){
      [self fetchAlbumArtForCurrentTrack];
    }
  }
}

- (void)fetchAlbumArtForCurrentTrack
{
  SPTrack* track = [[NMSpotifyService sharedService] currentlyPlayingTrack];
  [_artistLabel setStringValue:[[track artists][0] name]];
  [_trackLabel setStringValue:[track name]];
  [_albumLabel setStringValue:[[track album] name]];
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
            if( [[NMSpotifyService sharedService] currentlyPlayingTrack] == track )
              [_albumArtView setImage:img];
          });
        }
      }
    }
  });

}


@end
