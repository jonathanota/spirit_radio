//
//  SpiritRadioAppDelegateSpec.m
//  Spirit Radio
//
//  Created by Max Hawkins on 11/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cedar-iPhone/SpecHelper.h>
#define HC_SHORTHAND
#import <OCHamcrest-iPhone/OCHamcrest.h>
#import <OCMock-iPhone/OCMock.h>

#import "SpiritRadioAppDelegate.h"
#import "SpiritRadioViewController.h"

SPEC_BEGIN(SpiritRadioAppDelegateSpec)

describe(@"SpiritRadioAppDelegate", ^{
    __block SpiritRadioAppDelegate *appDelegate;
    
    beforeEach(^{
        appDelegate = [[SpiritRadioAppDelegate alloc] init];
    });

	afterEach(^{
        [appDelegate release];
	});

    it(@"has a window", ^{
        assertThat(appDelegate.window, is(notNilValue()));
    });
    
    it(@"has a window frame same size as the screen", PENDING);
    
    it(@"has SpiritRadioViewController for a viewControllerClass", ^{
        assertThat(appDelegate.viewControllerClass, is(equalTo([SpiritRadioViewController class])));
    });
    
});

SPEC_END
