//
//  SpiritRadioViewController.h
//  Spirit Radio
//
//  Created by Max Hawkins on 11/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <OpenAL/al.h>

#import <MediaPlayer/MediaPlayer.h>

#import "ObjectAL.h"

@class RadarView;
@class ALSource;
@class EWStreamBufferData;

@interface SpiritRadioViewController : UIViewController {
    RadarView *mRadarView;
    
    ALSource *staticSource;
    
    NSMutableArray *sources;
    MPMoviePlayerController *noisePlayer;
}

@property (readonly) RadarView *radarView;

- (void) setStatic:(CGFloat)amount;

@end
