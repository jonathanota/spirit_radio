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

- (NSMutableArray *) sources {
    @synchronized(self) {
        return mSources;
    }
}

- (CALayer *) sourceDot {
    CALayer *dot = [CALayer layer];
    dot.bounds = CGRectMake(0,0,16,16);
    dot.cornerRadius = dot.bounds.size.width / 2;
    dot.contents = (id) [UIImage imageNamed:@"dot"].CGImage;
    dot.opaque = NO;
    dot.hidden = YES;
    
    return dot;
}

- (void) setSources:(NSMutableArray *)sources {
    @synchronized(self) {
        [mSources release];
        mSources = [sources retain];
        
        // Dump the old layers
        for (CALayer *layer in sourceLayers) {
            [layer removeFromSuperlayer];
        }
        [sourceLayers removeAllObjects];
        
        // Make a layer for each object
        for (int i=0; i < [mSources count]; i++) {
            CALayer *dot = [self sourceDot];
            [sourceLayers addObject:dot];
            [self.layer addSublayer:dot];
        }
    }
}

- (CGPoint) originCoord {
    @synchronized(self) {
        return originCoord;
    }
}

- (void) setOriginCoord:(CGPoint)newCoord {
    @synchronized(self) {
        originCoord = newCoord;
        
        for (int i = 0; i < [self.sources count]; i++) {
            ALSource *source = [self.sources objectAtIndex:i];
            CALayer *layer = [sourceLayers objectAtIndex:i];
            
            CGPoint sourcePosition = CGPointMake(source.position.x, source.position.y);
            
            CGAffineTransform transformRelativeOrigin = CGAffineTransformMakeTranslation(-originCoord.x, -originCoord.y);
            
            CGPoint sourceRelativeOrigin = CGPointApplyAffineTransform(sourcePosition, transformRelativeOrigin);
            
            CGFloat x = sourceRelativeOrigin.x;
            CGFloat y = sourceRelativeOrigin.y;
            
            // bleh if x=0
            CGFloat intensity = 1.0 / ( exp( (sqrt(x*x+y*y)-200)/200.0 + 1.0 ) );
            CGFloat r = 1.0 - intensity;
            CGFloat t;
            if (x!=0) {
                t = atan2(y,x);
            } else {
                t = (y >= 0) ? M_PI / 2 : -M_PI/2;
            }
            
            CGPoint pointLogScaled = CGPointMake(self.bounds.size.width/2 * r*cos(t), self.bounds.size.width/2 * r*sin(t));
            
            CGAffineTransform centerTransform = CGAffineTransformMakeTranslation(self.bounds.size.width/2, self.bounds.size.height/2);
            CGPoint pointScaledCentered = CGPointApplyAffineTransform(pointLogScaled, centerTransform);
            
            layer.position = pointScaledCentered;
            layer.opacity = intensity;
            layer.hidden = NO;
        }
    }
}

- (void) setOriginOrientation:(CGFloat)newOrientation {
    @synchronized(self) {
        mOriginOrientation = newOrientation;
        
        
        [UIView beginAnimations:nil context:NULL];
        self.transform = CGAffineTransformMakeRotation(newOrientation);
        [UIView commitAnimations];
    }
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
//        sourcesLayer = [CALayer layer];
//        [self.layer addSublayer:sourcesLayer];
        
        mSources = [[NSMutableArray alloc] init];
        sourceLayers = [[NSMutableArray alloc] init];
        
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
    
    [sourceLayers release];
    
    [super dealloc];
}


@end
