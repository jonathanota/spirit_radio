//
//  SpiritRadioViewController.h
//  Spirit Radio
//
//  Created by Max Hawkins on 11/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RadarView;

@interface SpiritRadioViewController : UIViewController {
    RadarView *mRadarView;
}

@property (readonly) RadarView *radarView;

@end
