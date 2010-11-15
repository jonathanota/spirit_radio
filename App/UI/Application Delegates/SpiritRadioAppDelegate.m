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

- (void) resetButtonPressed:(id)sender {
    self.radioViewController.source2.position = alpoint(mOrigin.x, mOrigin.y, 0);
}

- (id) init {
    self = [super init];
    if (self) {
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
        self.radioViewController = [[SpiritRadioViewController alloc] init];
        [self.window addSubview:self.radioViewController.view];
        
        UIButton *resetButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        resetButton.frame = CGRectMake(170, 20, 75, 75);
        resetButton.titleLabel.text = @"Set Location";
        [resetButton addTarget:self action:@selector(resetButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.window addSubview:resetButton];
        
        [NSTimer scheduledTimerWithTimeInterval:(1.0/60.0) target:self selector:@selector(updateViews) userInfo:nil repeats:YES];
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
    
    [self.radioViewController setStatic:num];
//    [self.radioViewController setStatic:0];
    
    self.radioViewController.debugLabel.text = [NSString stringWithFormat:@"lat: %d\nlon: %d\nacc: %d\nhead: %d", (int) mOrigin.x, (int)mOrigin.y,(int) gpsAcc, (int) (mRadians*(180.0/M_PI))];
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
    mOrigin = CGPointMake(newLocation.coordinate.latitude * pow(10, 6), newLocation.coordinate.longitude * pow(10, 6));
    [OpenALManager sharedInstance].currentContext.listener.position = alpoint(mOrigin.x, mOrigin.y, 0);
    
    self.radioViewController.radarView.originCoord = mOrigin;
    
    gpsAcc = newLocation.horizontalAccuracy;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [mRadioViewController release];
    [window release];
    [super dealloc];
}


@end
