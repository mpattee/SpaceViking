//
//  RadarDish.m
//  SpaceViking
//
//  Created by Mike Pattee on 8/22/11.
//  Copyright 2011 Cordax Software LLC. All rights reserved.
//

#import "RadarDish.h"


@implementation RadarDish
@synthesize tiltingAnim;
@synthesize transmittingAnim;
@synthesize takingAHitAnim;
@synthesize blowingUpAnim;

- (void)dealloc
    {
    [tiltingAnim release];
    [transmittingAnim release];
    [takingAHitAnim release];
    [blowingUpAnim release];
    [super dealloc];
    }
    
- (void)changeState:(CharacterStates)newState
    {
    [self stopAllActions];
    id action = nil;
    [self setCharacterState:newState];
    
    switch (newState)
        {
        case kStateSpawning:
            CCLOG(@"RadarDish->starting the spawning animation");
            action = [CCAnimate actionWithAnimation:self.tiltingAnim restoreOriginalFrame:NO];
            break;
        case kStateIdle:
            CCLOG(@"RadarDish->Changing state to idle");
            action = [CCAnimate actionWithAnimation:self.transmittingAnim restoreOriginalFrame:NO];
            break;
        case kStateTakingDamage:
            CCLOG(@"RadarDish->Changing State to TakingDamage");
            self.characterHealth = self.characterHealth - [vikingCharacter getWeaponDamage];
            if (self.characterHealth <= 0.0f)
                {
                [self changeState:kStateDead];
                }
            else
                {
                action = [CCAnimate actionWithAnimation:self.takingAHitAnim restoreOriginalFrame:NO];
                }
            break;
        case kStateDead:
            CCLOG(@"RadarDish->Changing State to Dead");
            action = [CCAnimate actionWithAnimation:self.blowingUpAnim restoreOriginalFrame:NO];
            break;
        default:
            CCLOG(@"Unhandled state %d in RadarDish", newState);
            break;
        }
    if (action != nil)
        {
        [self runAction:action];
        }
    }

- (void)updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray *)listOfGameObjects
    {
    if (self.characterState == kStateDead)
        return;
    
    vikingCharacter = (GameCharacter *)[[self parent] getChildByTag:kVikingSpriteTagValue];
    
    CGRect vikingBoundingBox = [vikingCharacter adjustedBoundingBox];
    CharacterStates vikingState = [vikingCharacter characterState];
    // calculate if the viking is attacking and nearby
    if ((vikingState == kStateAttacking) && (CGRectIntersectsRect([self adjustedBoundingBox], vikingBoundingBox)))
        {
        if (self.characterState != kStateTakingDamage) 
            {
            // if RadarDish is NOT already taking damage
            [self changeState:kStateTakingDamage];
            return;
            }
        }
    
    if (([self numberOfRunningActions] == 0) && (self.characterState != kStateDead))
        {
        CCLOG(@"Going to idle");
        [self changeState:kStateIdle];
        return;
        }
    }

- (void)initAnimations
    {
    [self setTiltingAnim:[self loadPlistForAnimationWithName:@"tiltingAnim" andClassName:NSStringFromClass([self class])]];
    [self setTransmittingAnim:[self loadPlistForAnimationWithName:@"transmittingAnim" andClassName:NSStringFromClass([self class])]];
    [self setTakingAHitAnim:[self loadPlistForAnimationWithName:@"takingAHitAnim" andClassName:NSStringFromClass([self class])]];
    [self setBlowingUpAnim:[self loadPlistForAnimationWithName:@"blowingUpAnim" andClassName:NSStringFromClass([self class])]];
    }

- (id)init
    {
    self = [super init];
    if (self)
        {
        CCLOG(@"### RadarDish initialized");
        [self initAnimations];
        self.characterHealth = 100.0f;
        self.gameObjectType = kEnemyTypeRadarDish;
        [self changeState:kStateSpawning];
        }
    return self;
    }

@end
