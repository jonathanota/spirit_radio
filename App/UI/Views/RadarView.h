//
//  RadarView.h
//  Spirit Radio
//
//  Created by Max Hawkins on 11/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RadarView : UIView {
    CALayer *mScreenCircle;
    CALayer *mOriginCircle;
}

@property (readonly) CALayer *screenCircle;
@property (readonly) CALayer *originCircle;

@end
