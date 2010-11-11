//
//  RadarViewSpec.m
//  Spirit Radio
//
//  Created by Max Hawkins on 11/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cedar-iPhone/SpecHelper.h>
#define HC_SHORTHAND
#import <OCHamcrest-iPhone/OCHamcrest.h>
#import <OCMock-iPhone/OCMock.h>

#import "RadarView.h"
#import <QuartzCore/QuartzCore.h>

SPEC_BEGIN(RadarViewSpec)

describe(@"RadarView", ^{
    __block RadarView *radarView;
    
    beforeEach(^{
        radarView = [[RadarView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    });

	afterEach(^{
        [radarView release];
	});
    
    it(@"autoresizes subviews", ^{
        assertThatBool(radarView.autoresizesSubviews, equalToBool(YES));
    });
    
    describe(@"originCircle layer", ^{
        
        __block CALayer *originCircle;
        
        beforeEach(^{
            originCircle = radarView.originCircle;
        });
        
        it(@"exists", ^{
            assertThat(originCircle, is(notNilValue()));
        });
        
        it(@"is assigned to view's layer", ^{
            assertThat(originCircle.superlayer, is(equalTo(radarView.layer)));
        });
        
        it(@"is round", ^{
            assertThatFloat(originCircle.cornerRadius, closeTo(originCircle.bounds.size.width / 2, 0.001));
        });
        
        it(@"has width 10", ^{
            assertThatInt(originCircle.bounds.size.width, equalToInt(10));
        });
        
        it(@"has height 10", ^{
            assertThatInt(originCircle.bounds.size.height, equalToInt(10));
        });
        
        it(@"has x position at view's center x", ^{
            assertThatInt(originCircle.position.x, equalToInt(radarView.center.x));
        });
        
        it(@"has y position at view's center y", ^{
            assertThatInt(originCircle.position.y, equalToInt(radarView.center.y));
        });
        
        it(@"has anchor point that makes its position its center", ^{
            assertThatFloat(originCircle.anchorPoint.x, closeTo(0.5, 0.001));
            assertThatFloat(originCircle.anchorPoint.y, closeTo(0.5, 0.001));
        });
        
        it(@"has a green background", ^{
            assertThat([UIColor colorWithCGColor:originCircle.backgroundColor], is(equalTo([UIColor greenColor])));
        });
        
    });
    
    describe(@"screenCircle layer", ^{
        
        __block CALayer *screenCircle;
        
        beforeEach(^{
            screenCircle = radarView.screenCircle;
        });
        
        it(@"exists", ^{
            assertThat(screenCircle, is(notNilValue()));
        });
        
        it(@"is assigned to view's layer", ^{
            assertThat(screenCircle.superlayer, is(equalTo(radarView.layer)));
        });
        
        it(@"has a black background", ^{
            assertThat([UIColor colorWithCGColor:screenCircle.backgroundColor], is(equalTo([UIColor blackColor])));
        });
        
        it(@"is round", ^{
            assertThatFloat(screenCircle.cornerRadius, closeTo(screenCircle.bounds.size.width / 2, 0.001));
        });
        
        describe(@"border", ^{
        
            it(@"is green", ^{            
                assertThat([UIColor colorWithCGColor:screenCircle.borderColor], is(equalTo([UIColor greenColor])));
            });
            
            it(@"is 2px wide", ^{
                assertThatFloat(screenCircle.borderWidth, closeTo(2.0, 0.001));
            });
            
        });
        
        describe(@"frame", ^{
            
            __block CGRect frame;
            
            beforeEach(^{
                frame = screenCircle.frame;
            });
            
            it(@"matches view's bounds", ^{
                assertThatInt(frame.size.width, equalToInt(radarView.bounds.size.width));
                assertThatInt(frame.size.height, equalToInt(radarView.bounds.size.height));
            });
            
            describe(@"when view's bounds change", ^{
            
                beforeEach(^{
                    radarView.bounds = CGRectMake(0, 0, 50, 50);
                });
                
                it(@"matches view's bounds", PENDING);
                
            });
            
        });
        
    });

});

SPEC_END
