//
//  RadarView.m
//  Spirit Radio
//
//  Created by Max Hawkins on 11/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RadarView.h"

#import <QuartzCore/QuartzCore.h>

@implementation RadarView

- (CALayer *) screenCircle {
    if (!mScreenCircle) {
        mScreenCircle = [[CALayer layer] retain];
        mScreenCircle.frame = self.bounds;
        mScreenCircle.backgroundColor = [UIColor blackColor].CGColor;
        mScreenCircle.cornerRadius = self.bounds.size.width / 2;
        mScreenCircle.borderColor = [UIColor colorWithRed:(50.0/255.0) green:(48.0/255.0) blue:(44.0/255.0) alpha:1].CGColor;
        mScreenCircle.borderWidth = 5.0;
        mScreenCircle.shadowRadius = 10.0;
        mScreenCircle.shadowColor = [UIColor blackColor].CGColor;
        mScreenCircle.shadowOpacity = 1.0;
        mScreenCircle.contents = [UIImage imageNamed:@"radar"].CGImage;
    }
    return mScreenCircle;
}

- (CALayer *) originCircle {
    if (!mOriginCircle) {
        mOriginCircle = [[CALayer layer] retain];
        mOriginCircle.bounds = CGRectMake(0, 0, 10, 10);
        mOriginCircle.cornerRadius = mOriginCircle.bounds.size.width / 2;
        mOriginCircle.position = self.center;
        mOriginCircle.backgroundColor = [UIColor greenColor].CGColor;
    }
    return mOriginCircle;
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        
        [self.layer addSublayer:self.screenCircle];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
    [mScreenCircle release];
    [mOriginCircle release];
    
    [super dealloc];
}


@end
