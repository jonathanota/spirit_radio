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

@synthesize debugLabel, source2;

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
        
        noisePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[[NSBundle mainBundle] URLForResource:@"noise_compressed" withExtension:@"mp4"]];
        noisePlayer.view.frame = self.view.bounds;
        noisePlayer.shouldAutoplay = YES;
        noisePlayer.controlStyle = MPMovieControlStyleNone;
        noisePlayer.repeatMode = MPMovieRepeatModeOne;
        noisePlayer.view.alpha = 0.1;
        [self.view addSubview:noisePlayer.view];
        [noisePlayer play];
        
        debugLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 150, 50)];
        debugLabel.font = [UIFont systemFontOfSize:9.0];
        debugLabel.numberOfLines = 4;
        [self.view addSubview:debugLabel];
        
    }
    return self;
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (void) updateQueue {
    [coolBufferData updateQueue:source2.sourceId];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    

    [OALSimpleAudio sharedInstanceWithSources:32];
    
    ALSource *source = [[ALSource source] retain];
    ALBuffer *laughBuffer = [[[OALAudioSupport sharedInstance] bufferFromFile:@"laugh.wav"] retain];
    
    source.position = alpoint(40450510.000000, -79930090.000000, 0);
    source.referenceDistance = 50;
    source.rolloffFactor = 20;
    
    [source play:laughBuffer loop:YES];
    
    source2 = [[ALSource source] retain];
    coolBufferData = [[EWStreamBufferData streamBufferDataFromFileBaseName:@"librarian"] retain];
    coolBufferData.audioLooping = YES;
    
    source2.position = alpoint(40450420.000000, -79930590.000000, 0);
    source2.referenceDistance = 50;
    source2.rolloffFactor = 20;
    
    [NSTimer scheduledTimerWithTimeInterval:(1.0/30.0) target:self selector:@selector(updateQueue) userInfo:nil repeats:YES];
    
//    [OALSimpleAudio sharedInstanceWithSources:32];
//    
////    staticSource = [[ALSource source]retain];
////    ALBuffer *staticBuffer = [[[OALAudioSupport sharedInstance] bufferFromFile:@"static.wav"] retain];    
////    staticSource.gain = 0;
////    [staticSource play:staticBuffer loop:YES];
//    
//    ALSource *source = [[ALSource source]retain];
//    ALBuffer *buffer = [[[OALAudioSupport sharedInstance] bufferFromFile:@"laugh.wav"] retain];
//    //40441684, -79942748
//    //40450220.000000, -79930456.000000
//    source.position = alpoint(0, 0, 0);
//    source.referenceDistance = 40.0;
//    source.rolloffFactor = 5.0;
//    source.coneOuterGain = 0.0;
//    source.gain = 1;
//    
//    static  alcMacOSXRenderingQualityProcPtr    proc = NULL;
//    
//    if (proc == NULL) {
//        proc = (alcMacOSXRenderingQualityProcPtr) alcGetProcAddress(NULL, (const ALCchar*) "alcMacOSXRenderingQuality");
//    }
//    
//    if (proc)
//        proc(ALC_IPHONE_SPATIAL_RENDERING_QUALITY_HEADPHONES);
//    else {
//        NSLog(@"proc's a no go");
//    }
//    
//    [OpenALManager sharedInstance].currentContext.distanceModel = AL_EXPONENT_DISTANCE;
//    
//    [source play:buffer loop:YES];
//    
//    sources = [[NSMutableArray alloc] init];
//    [sources addObject:source];
    
    self.radarView.source = source2;
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
