//
//  GameScene.m
//  SpaceViking
//
//  Created by Mike Pattee on 8/19/11.
//  Copyright 2011 Cordax Software LLC. All rights reserved.
//

#import "GameScene.h"

#import "BackgroundLayer.h"
#import "GameplayLayer.h"

@implementation GameScene

- (id)init
    {
    self = [super init];
    if (self)
        {
        BackgroundLayer *backgroundLayer = [BackgroundLayer node];
        [self addChild:backgroundLayer z:0];
        GameplayLayer *gameplayLayer = [GameplayLayer node];
        [self addChild:gameplayLayer z:5];
        }
    return self;
    }

@end
