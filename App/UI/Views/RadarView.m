//
//  RadarView.m
//  Spirit Radio
//
//  Created by Max Hawkins on 11/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RadarView.h"

#import <QuartzCore/QuartzCore.h>

#import "ObjectAL.h"

@implementation RadarView

@synthesize originOrientation = mOriginOrientation;
@synthesize sources = mSources;

- (CALayer *) newSourceLayer {
    CALayer *sourceLayer = [CALayer layer];
    sourceLayer.bounds = CGRectMake(0, 0, 16, 16);
    sourceLayer.cornerRadius = mOriginCircle.bounds.size.width / 2;
    sourceLayer.contents = (id) [UIImage imageNamed:@"dot"].CGImage;
    sourceLayer.opaque = NO;
    
    return sourceLayer;
}

- (void) setSources:(NSMutableArray *)sources {
    mSources = sources;
    if (dict) {
        CFRelease(dict);
    }
    dict = CFDictionaryCreateMutable(NULL, 0, NULL, NULL);
    for (ALSource *source in sources) {
        CFDictionarySetValue(dict, source, [self newSourceLayer]);
    }
}


- (CGPoint) originCoord {
    return originCoord;
}

- (void) setOriginCoord:(CGPoint)newCoord {
    originCoord = newCoord;
    
    [sourcesLayer removeFromSuperlayer];
    [sourcesLayer release];
    
    for (ALSource *source in self.sources) {
        CALayer *layer = (CALayer *) CFDictionaryGetValue(dict, source);
        
        CGPoint sourcePosition = CGPointMake(source.position.x, source.position.y);
        
        CGAffineTransform transformRelativeOrigin = CGAffineTransformMakeTranslation(-originCoord.x, -originCoord.y);
        
        CGPoint sourceRelativeOrigin = CGPointApplyAffineTransform(sourcePosition, transformRelativeOrigin);
        
        CGFloat x = sourceRelativeOrigin.x;
        CGFloat y = sourceRelativeOrigin.y;
        
        // bleh if x=0
        CGFloat intensity = 1.0 / ( exp( (sqrt(x*x+y*y)-200)/200.0 ) + 1.0 );
        CGFloat r = 1.0 - intensity;
        CGFloat t = atan2(y,x);
        
        CGPoint pointLogScaled = CGPointMake(self.bounds.size.width/2 * -r*cos(t), self.bounds.size.width/2 * -r*sin(t));
        
        CGAffineTransform centerTransform = CGAffineTransformMakeTranslation(self.bounds.size.width/2, self.bounds.size.height/2);
        CGPoint pointScaledCentered = CGPointApplyAffineTransform(pointLogScaled, centerTransform);
        
        layer.position = pointScaledCentered;
        layer.opacity = intensity;
        
        [sourcesLayer addSublayer:layer];
    }
}

- (void) setOriginOrientation:(CGFloat)newOrientation {
    mOriginOrientation = newOrientation;
    
    
    [UIView beginAnimations:nil context:NULL];
    self.transform = CGAffineTransformMakeRotation(newOrientation);
    [UIView commitAnimations];
}

- (CALayer *) screenCircle {
    if (!mScreenCircle) {
        mScreenCircle = [[CALayer layer] retain];
        mScreenCircle.frame = self.bounds;
        mScreenCircle.borderColor = [UIColor colorWithRed:(50.0/255.0) green:(48.0/255.0) blue:(44.0/255.0) alpha:1].CGColor;
        mScreenCircle.cornerRadius = self.bounds.size.width / 2;
        mScreenCircle.borderWidth = 5.0;
//        mScreenCircle.shadowRadius = 10.0;
//        mScreenCircle.shadowColor = [UIColor blackColor].CGColor;
//        mScreenCircle.shadowOpacity = 1.0;
        mScreenCircle.contents = (id) [UIImage imageNamed:@"radar"].CGImage;
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
//        self.opaque = NO;
//        self.backgroundColor = [UIColor clearColor];
        sourcesLayer = [CALayer layer];
        [self.layer addSublayer:sourcesLayer];
        
        mSources = [[NSMutableArray alloc] init];
        
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
    CFRelease(dict);
    
    [mScreenCircle release];
    [mOriginCircle release];
    
    [mSources release];
    
    [super dealloc];
}


@end
