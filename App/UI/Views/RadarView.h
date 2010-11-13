//
//  RadarView.h
//  Spirit Radio
//
//  Created by Max Hawkins on 11/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ALSource.h"

@interface RadarView : UIView {
    CALayer *mScreenCircle;
    CALayer *mOriginCircle;
    
    NSArray *sources;
    ALSource *source;
    CALayer *sourceLayer;
    
    CGPoint originCoord;
    
    NSMutableDictionary *dict;
}

@property (readonly) CALayer *screenCircle;
@property (readonly) CALayer *originCircle;

@property (retain) NSArray *sources;
@property (retain) ALSource *source;
@property (assign) CGPoint originCoord;
@property (nonatomic, assign) CGFloat originOrientation;

@end
