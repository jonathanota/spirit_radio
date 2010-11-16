    //
//  SpiritRadioViewController.m
//  Spirit Radio
//
//  Created by Max Hawkins on 11/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SpiritRadioViewController.h"

#import <QuartzCore/QuartzCore.h>
#import <MediaPlayer/MediaPlayer.h>

#import "EWStreamBufferData.h"

#import "RadarView.h"

@implementation SpiritRadioViewController

@synthesize sources = mSources;

- (UIView *) view {
    UIView *view = [super view];
    if (view) {
        view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    }
    return view;
}

- (RadarView *) radarView {
    if (!mRadarView) {
        mRadarView = [[RadarView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width)];
        mRadarView.center = self.view.center;
    }
    return mRadarView;
}

- (id) init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (NSMutableArray *) defaultSources {
    NSMutableArray *defaultSources = [NSMutableArray array];
    
    for (NSString *fileName in [NSArray arrayWithObjects:@"librarian", nil]) {
        ALSource *source = [ALSource source];
        EWStreamBufferData *streamBuffer = [EWStreamBufferData streamBufferDataFromFileBaseName:fileName];
        streamBuffer.audioLooping = YES;
        source.position = alpoint(40441436.0, -79943544.0, 0);
        source.referenceDistance = 50;
        source.rolloffFactor = 20;
        [defaultSources addObject:source];
    }
    
    return defaultSources;
}

- (void) updateQueue {
    [coolBufferData updateQueue:mySource.sourceId];
    [source2.streamBuffer updateQueue:source2.sourceId];
    [buffer3 updateQueue:source3.sourceId];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self.view addSubview:self.radarView];
    
    noisePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[[NSBundle mainBundle] URLForResource:@"noise_compressed" withExtension:@"mp4"]];
    noisePlayer.view.frame = self.view.bounds;
    noisePlayer.shouldAutoplay = YES;
    noisePlayer.controlStyle = MPMovieControlStyleNone;
    noisePlayer.repeatMode = MPMovieRepeatModeOne;
    noisePlayer.view.alpha = 0.1;
    [self.view addSubview:noisePlayer.view];
    [noisePlayer play];
    
    [OALSimpleAudio sharedInstanceWithSources:32];
    
    mySource = [[ALSource source] retain];
    coolBufferData = [[EWStreamBufferData streamBufferDataFromFileBaseName:@"ColdFunk"] retain];
    coolBufferData.audioLooping = YES;
    
    mySource.position = alpoint(100,0,0);
    mySource.referenceDistance = 50;
    mySource.rolloffFactor = 20;
    
    source2 = [[ALSource source] retain];
    source2.streamBuffer = [EWStreamBufferData streamBufferDataFromFileBaseName:@"laugh"];
    buffer2.audioLooping = YES;
    
    source2.position = alpoint(-100,0,0);
    source2.referenceDistance = 50;
    source2.rolloffFactor = 20;
    
    
    source3 = [[ALSource source] retain];
    buffer3 = [[EWStreamBufferData streamBufferDataFromFileBaseName:@"librarian"] retain];
    buffer3.audioLooping = YES;
    
    source3.position = alpoint(-50,-100,0);
    source3.referenceDistance = 50;
    source3.rolloffFactor = 20;
    
    
    
    [NSTimer scheduledTimerWithTimeInterval:(1.0/30.0) target:self selector:@selector(updateQueue) userInfo:nil repeats:YES];
}

- (void) setStatic:(CGFloat)amount {
    staticSource.gain = amount;
    noisePlayer.view.alpha = amount;
}

- (void)dealloc {
    [mRadarView release];
    
    [super dealloc];
}


@end
