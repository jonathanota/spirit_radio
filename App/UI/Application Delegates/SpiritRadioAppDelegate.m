//
//  SpiritRadioAppDelegate.m
//  SpiritRadio
//
//  Created by Max Hawkins on 11/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SpiritRadioAppDelegate.h"

#import <CoreLocation/CoreLocation.h>

#import "SpiritRadioViewController.h"
#import "RadarView.h"

@implementation SpiritRadioAppDelegate

@synthesize window;
@synthesize radioViewController = mRadioViewController;

- (Class) viewControllerClass {
    return [SpiritRadioViewController class];
}

#pragma mark -
#pragma mark Application lifecycle

- (void) toggleDemoMode:(id)sender {
    isInDemoMode = !isInDemoMode;
}

- (void) toggleDebugMode:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        debugLabel.hidden = !debugLabel.hidden;
    }
}

- (id) init {
    self = [super init];
    if (self) {
        isInDemoMode = YES;
        
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
        self.radioViewController = [[SpiritRadioViewController alloc] init];
        [self.window addSubview:self.radioViewController.view];
        
        UISwipeGestureRecognizer *demoModeToggle = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(toggleDemoMode:)];
        demoModeToggle.numberOfTouchesRequired = 2;
        demoModeToggle.direction = UISwipeGestureRecognizerDirectionDown;
        [self.window addGestureRecognizer:demoModeToggle];
        
        UILongPressGestureRecognizer *debugToggle = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(toggleDebugMode:)];
        debugToggle.minimumPressDuration = 2.0;
        [self.window addGestureRecognizer:debugToggle];
        
        [NSTimer scheduledTimerWithTimeInterval:(1.0/60.0) target:self selector:@selector(updateViews) userInfo:nil repeats:YES];
        
        debugLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 20, 150, 50)];
        debugLabel.font = [UIFont systemFontOfSize:9.0];
        debugLabel.numberOfLines = 4;
        debugLabel.hidden = YES;
        [self.window addSubview:debugLabel];
    }
    return self;
}

- (void) updateViews {
    self.radioViewController.radarView.originOrientation = mRadians;
    self.radioViewController.radarView.originCoord = mOrigin;
    
    [OpenALManager sharedInstance].currentContext.listener.orientation = alorientation(cos(mRadians), sin(mRadians), 0, 0, 0, 1);
    
    CGFloat num = gpsAcc/55.0/2.0 + headingWrong/2.0;
    num = MIN(num, 1);
    num = MAX(num, 0);
    if(num < 0.1) num = 0;
    
    if (isInDemoMode) {
        [self.radioViewController setStatic:0];
    } else {
        [self.radioViewController setStatic:num];
    }
    
    debugLabel.text = [NSString stringWithFormat:@"lat: %d\nlon: %d\nacc: %d\nhead: %d", (int) mOrigin.x, (int)mOrigin.y,(int) gpsAcc, (int) (mRadians*(180.0/M_PI))];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    [self.window makeKeyAndVisible];

    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingHeading];
    [locationManager startUpdatingLocation];
    
    return YES;
}

- (void) locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    CLLocationDirection heading = newHeading.trueHeading;
    mRadians = (90.0 - heading) * (M_PI/180.0);
    
    headingWrong = newHeading.headingAccuracy < 0;
    
}

- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    if (isInDemoMode) {
        mOrigin = CGPointZero;
    } else {
        mOrigin = CGPointMake(newLocation.coordinate.latitude * pow(10, 6), newLocation.coordinate.longitude * pow(10, 6));
    }
    
    
    [OpenALManager sharedInstance].currentContext.listener.position = alpoint(mOrigin.x, mOrigin.y, 0);
    
    self.radioViewController.radarView.originCoord = mOrigin;
    
    gpsAcc = newLocation.horizontalAccuracy;
}

- (void)dealloc {
    [mRadioViewController release];
    [window release];
    [super dealloc];
}


@end
