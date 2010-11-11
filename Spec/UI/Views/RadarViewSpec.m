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
    
    it(@"is transparent", ^{
        assertThatBool(radarView.opaque, equalToBool(NO));
    });
    
    it(@"has transparent background", ^{
        assertThat(radarView.backgroundColor, is(equalTo([UIColor clearColor])));
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
