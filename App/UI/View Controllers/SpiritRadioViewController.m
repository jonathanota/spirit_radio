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

#import "RadarView.h"

@implementation SpiritRadioViewController

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

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

- (id) init {
    self = [super init];
    if (self) {
        [self.view addSubview:self.radarView];
        
//        [OALSimpleAudio sharedInstanceWithSources:32];
        
//        BOOL source_available = [[OpenALSoundController sharedSoundController] reserveSource:&backgroundMusicSourceID];
//        if(YES == source_available)
//        {
//            backgroundMusicStreamBufferData = [[EWStreamBufferData alloc] initFromFileBaseName:@"D-ay-Z-ray_mix_090502"];
//            backgroundMusicStreamBufferData.audioLooping = YES;
//            
//            [[OpenALSoundController sharedSoundController] setSourceGain:0.50 sourceID:backgroundMusicSourceID];		
//            [[OpenALSoundController sharedSoundController] playStream:backgroundMusicSourceID streamBufferData:backgroundMusicStreamBufferData];		
//        }
//        else
//        {
//            NSLog(@"Unexpected Error: No AL source available for background music");
//        }
        
//        staticSource = [[ALSource source]retain];
//        ALBuffer *staticBuffer = [[[OALAudioSupport sharedInstance] bufferFromFile:@"static.wav"] retain];    
//        staticSource.gain = 0;
//        [staticSource play:staticBuffer loop:YES];
//        
//        source.position = alpoint(0, 0, 0);
//        source.referenceDistance = 40;
//        source.gain = 1.0;
//        
//        [OpenALManager sharedInstance].currentContext.distanceModel = AL_EXPONENT_DISTANCE;
//        
//        [OpenALManager sharedInstance].currentContext.listener.position = alpoint(0, 0, 0);
        
        noisePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[[NSBundle mainBundle] URLForResource:@"noise_compressed" withExtension:@"mp4"]];
        noisePlayer.view.frame = self.view.bounds;
        noisePlayer.shouldAutoplay = YES;
        noisePlayer.controlStyle = MPMovieControlStyleNone;
        noisePlayer.repeatMode = MPMovieRepeatModeOne;
        noisePlayer.view.alpha = 0.1;
        [self.view addSubview:noisePlayer.view];
        [noisePlayer play];
        
    }
    return self;
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [OALSimpleAudio sharedInstanceWithSources:32];
    
    staticSource = [[ALSource source]retain];
    ALBuffer *staticBuffer = [[[OALAudioSupport sharedInstance] bufferFromFile:@"static.wav"] retain];    
    staticSource.gain = 0;
    [staticSource play:staticBuffer loop:YES];
    
    ALSource *source = [[ALSource source]retain];
    ALBuffer *buffer = [[[OALAudioSupport sharedInstance] bufferFromFile:@"spooky.wav"] retain];
    //40441684, -79942748
    source.position = alpoint(40441684, -79942748, 0);
    source.referenceDistance = 5.0;
    source.rolloffFactor = 5.0;
    source.coneOuterGain = 0.0;
    source.gain = 1;
    [source play:buffer loop:YES];
    
    sources = [[NSMutableArray alloc] init];
//    [sources addObject:source];
    
    self.radarView.source = source;
    
    [OpenALManager sharedInstance].currentContext.distanceModel = AL_EXPONENT_DISTANCE;
}

- (void) setStatic:(CGFloat)amount {
    staticSource.gain = amount;
    noisePlayer.view.alpha = amount;
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [mRadarView release];
    
    [super dealloc];
}


@end
