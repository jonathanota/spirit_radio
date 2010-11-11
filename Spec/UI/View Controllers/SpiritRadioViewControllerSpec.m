//
//  SpiritRadioViewControllerSpec.m
//  Spirit Radio
//
//  Created by Max Hawkins on 11/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cedar-iPhone/SpecHelper.h>
#define HC_SHORTHAND
#import <OCHamcrest-iPhone/OCHamcrest.h>
#import <OCMock-iPhone/OCMock.h>

#import "SpiritRadioViewController.h"
#import "RadarView.h"

SPEC_BEGIN(SpiritRadioViewControllerSpec)

describe(@"SpiritRadioViewController", ^{
    __block SpiritRadioViewController *viewController;
    
    beforeEach(^{
        viewController = [[SpiritRadioViewController alloc] init];
    });

	afterEach(^{
        [viewController release];
	});

    describe(@"RadarView subview", ^{
        
        __block RadarView *radarView;
        
        beforeEach(^{
            radarView = viewController.radarView;
        });
        
        it(@"should exist", ^{
            assertThat(radarView, is(notNilValue()));
        });
        
        it(@"should belong to viewController's view", ^{
            assertThat(radarView.superview, is(equalTo(viewController.view)));
        });
        
        it(@"should have width same size as view's width", ^{
            assertThatInt(radarView.bounds.size.width, equalToInt(viewController.view.bounds.size.width));
        });
        
        it(@"should have height same size as view's width", ^{
            assertThatInt(radarView.bounds.size.height, equalToInt(viewController.view.bounds.size.width));
        });
        
        it(@"should have center x same size as view's center x", ^{
            assertThatInt(radarView.center.x, equalToInt(viewController.view.center.x));
        });
        
        it(@"should have center y same size as view's center y", ^{
            assertThatInt(radarView.center.y, equalToInt(viewController.view.center.y));
        });
        
    });
});

SPEC_END
