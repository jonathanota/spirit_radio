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
@synthesize source;

- (NSArray *) sources {
    return sources;
}

- (NSMutableDictionary *) dict {
    if (!dict) {
        dict = [[NSMutableDictionary alloc] init];
    }
    return dict;
}

//- (void) setSources:(NSArray *)mySources {
//    NSLog(@"srcs");
//    sources = mySources;
//    NSLog(@"%@, %d", sources, [sources count]);
//    for (ALSource *source in sources) {
//        NSLog(@"create layer");
//        CALayer *layer = [CALayer layer];
//        layer.bounds = CGRectMake(0, 0, 10, 10);
//        layer.cornerRadius = mOriginCircle.bounds.size.width / 2;
//        layer.position = CGPointMake(source.position.x, source.position.y);
//        layer.backgroundColor = [UIColor greenColor].CGColor;
//        [self.layer addSublayer:layer];
//        [self.dict setObject:layer forKey:source];
//    }
//}

- (CALayer *) sourceLayer {
    if (!sourceLayer) {
        sourceLayer = [[CALayer layer] retain];
        sourceLayer.bounds = CGRectMake(0, 0, 16, 16);
        sourceLayer.cornerRadius = mOriginCircle.bounds.size.width / 2;
        sourceLayer.contents = [UIImage imageNamed:@"dot"].CGImage;
        sourceLayer.opaque = NO;
        [self.layer addSublayer:sourceLayer];
    }
    return sourceLayer;
}

- (CGPoint) originCoord {
    return originCoord;
}

- (void) setOriginCoord:(CGPoint)newCoord {
    originCoord = newCoord;
            
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
    
    self.sourceLayer.position = pointScaledCentered;
    self.sourceLayer.opacity = intensity;
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
//        self.opaque = NO;
//        self.backgroundColor = [UIColor clearColor];
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
