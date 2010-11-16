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

- (NSMutableArray *) sources {
    if (!mSources) {
        mSources = [[NSMutableArray alloc] init];
    }
    return mSources;
}

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

- (NSMutableArray *) sourcesFromPlist:(NSString *)plistName {
    NSMutableArray *defaultSources = [NSMutableArray array];
    
    NSString *defaultSourcePath = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    for(NSDictionary *sourceRecord in [NSArray arrayWithContentsOfFile:defaultSourcePath]) {
        NSString *baseName = [sourceRecord valueForKey:@"Base Name"];
        CGFloat x = [[sourceRecord valueForKeyPath:@"Position.x"] floatValue];
        CGFloat y = [[sourceRecord valueForKeyPath:@"Position.y"] floatValue];
        CGFloat z = [[sourceRecord valueForKeyPath:@"Position.z"] floatValue];
        ALPoint position = alpoint(x, y, z);
        
        ALSource *mySource = [ALSource source];
        mySource.streamBuffer = [EWStreamBufferData streamBufferDataFromFileBaseName:baseName];
        mySource.streamBuffer.audioLooping = YES;
        mySource.position = position;
        mySource.referenceDistance = 50;
        mySource.rolloffFactor = 20;
        
        [defaultSources addObject:mySource];
    };
    
    return defaultSources;
}

- (NSMutableArray *) defaultSources {
    return [self sourcesFromPlist:@"default_sources"];
}

- (NSMutableArray *) demoSources {
    return [self sourcesFromPlist:@"demo_sources"];
}

- (void) updateQueue {
    @synchronized(self.sources) { // Is this even necessary?
        for (ALSource *source in self.sources) {
            [source.streamBuffer updateQueue:source.sourceId];
        }
    }
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
    
    self.sources = [self defaultSources];
    
    [NSTimer scheduledTimerWithTimeInterval:(1.0/30.0) target:self selector:@selector(updateQueue) userInfo:nil repeats:YES];
    
    [self performSelector:@selector(switchit) withObject:nil afterDelay:5.0];
}

- (void) switchit {
    sourcesFaded = 0;
    for (ALSource *source in self.sources) {
        [source fadeTo:0 duration:0.5 target:self selector:@selector(finishSwitchit)];
    }
}

- (void) finishSwitchit {
    sourcesFaded++;
    if (sourcesFaded >= [self.sources count]) {
        self.sources = [self demoSources];
    }
}

- (void) setStatic:(CGFloat)amount {
    staticSource.gain = amount;
    noisePlayer.view.alpha = amount;
}

- (void)dealloc {
    [mSources release];
    [mRadarView release];
    
    [super dealloc];
}


@end
