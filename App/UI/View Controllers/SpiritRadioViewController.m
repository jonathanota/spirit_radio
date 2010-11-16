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

//- (NSArray *) demoSources {
//    
//}

- (void) setSources:(NSMutableArray *)sources {
    mSources = sources;
    self.radarView.sources = sources;
}

- (void) clearSources {
    [self.sources removeAllObjects];
    self.radarView.sources = self.sources;
}

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
        
        
        mSources = [[NSMutableArray alloc] init];
    }
    return self;
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

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
    for (ALSource *source in self.sources) {
        [source.streamBuffer updateQueue:source.sourceId];
    }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [OALSimpleAudio sharedInstanceWithSources:32];
    
    self.sources = self.defaultSources;
    
    [NSTimer scheduledTimerWithTimeInterval:(1.0/30.0) target:self selector:@selector(updateQueue) userInfo:nil repeats:YES];
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
