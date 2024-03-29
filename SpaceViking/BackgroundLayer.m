//
//  BackgroundLayer.m
//  SpaceViking
//
//  Created by Mike Pattee on 8/19/11.
//  Copyright 2011 Cordax Software LLC. All rights reserved.
//

#import "BackgroundLayer.h"


@implementation BackgroundLayer

- (id)init
    {
    self = [super init];
    if (self)
        {
        CCSprite *backgroundImage;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
            // Indicates game is running on iPad
            backgroundImage = [CCSprite spriteWithFile:@"background.png"];
            }
        else
            {
            backgroundImage = [CCSprite spriteWithFile:@"backgroundiPhone.png"];
            }
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        [backgroundImage setPosition:CGPointMake(screenSize.width/2, screenSize.height/2)];
        [self addChild:backgroundImage z:0 tag:0];
        }
    return self;
    }

@end
