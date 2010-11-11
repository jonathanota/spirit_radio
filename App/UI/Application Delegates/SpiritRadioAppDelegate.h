//
//  SpiritRadioAppDelegate.h
//  SpiritRadio
//
//  Created by Max Hawkins on 11/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class SpiritRadioViewController;

@interface SpiritRadioAppDelegate : NSObject <UIApplicationDelegate, CLLocationManagerDelegate> {
    UIWindow *window;
    SpiritRadioViewController *mRadioViewController;
    
    CLLocationManager *locationManager;
    
    CGFloat mRadians;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet SpiritRadioViewController *radioViewController;

@end

