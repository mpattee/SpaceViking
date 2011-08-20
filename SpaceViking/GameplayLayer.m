//
//  GameplayLayer.m
//  SpaceViking
//
//  Created by Mike Pattee on 8/19/11.
//  Copyright 2011 Cordax Software LLC. All rights reserved.
//

#import "GameplayLayer.h"


@implementation GameplayLayer

- (void)initJoystickAndButtons
    {
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CGRect joystickBaseDimensions = CGRectMake(0, 0, 128.0f, 128.0f);
    CGRect jumpButtonDimensions = CGRectMake(0, 0, 64.0f, 64.0f);
    CGRect attackButtonDimensions = CGRectMake(0, 0, 64.0f, 64.0f);
    CGPoint joystickBasePosition;
    CGPoint jumpButtonPosition;
    CGPoint attackButtonPosition;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
        // the device is ipad running iPhone 3.2 or later
        CCLOG(@"Positioning Joystick and Buttons for iPad");
        joystickBasePosition = ccp(screenSize.width * 0.0625f, screenSize.height * 0.052f);
        jumpButtonPosition = ccp(screenSize.width * 0.946f, screenSize.height * 0.052f);
        attackButtonPosition = ccp(screenSize.width * 0.947f, screenSize.height * 0.169f);
        }
    else
        {
        // the device is an iPhone or iPod Touch
        CCLOG(@"Positioning Joystick and Buttons for iPhone");
        joystickBasePosition = ccp(screenSize.width * 0.07f, screenSize.height * 0.11f);
        jumpButtonPosition = ccp(screenSize.width * 0.93f, screenSize.height * 0.11f);
        attackButtonPosition = ccp(screenSize.width * 0.93f, screenSize.height * 0.35f);
        }
    
    SneakyJoystickSkinnedBase *joystickBase = [[[SneakyJoystickSkinnedBase alloc] init] autorelease];
    joystickBase.position = joystickBasePosition;
    joystickBase.backgroundSprite = [CCSprite spriteWithFile:@"dpadDown.png"];
    joystickBase.thumbSprite = [CCSprite spriteWithFile:@"joystickDown.png"];
    joystickBase.joystick = [[SneakyJoystick alloc] initWithRect:joystickBaseDimensions];
    leftJoystick = [joystickBase.joystick retain];
    [self addChild:joystickBase];
    
    SneakyButtonSkinnedBase *jumpButtonBase = [[[SneakyButtonSkinnedBase alloc] init] autorelease];
    jumpButtonBase.position = jumpButtonPosition;
    jumpButtonBase.defaultSprite = [CCSprite spriteWithFile:@"jumpUp.png"];
    jumpButtonBase.activatedSprite = [CCSprite spriteWithFile:@"jumpDown.png"];
    jumpButtonBase.pressSprite = [CCSprite spriteWithFile:@"jumpDown.png"];
    jumpButtonBase.button = [[SneakyButton alloc] initWithRect:jumpButtonDimensions];
    jumpButton = [jumpButtonBase.button retain];
    jumpButton.isToggleable = NO;
    [self addChild:jumpButtonBase];
    
    SneakyButtonSkinnedBase *attackButtonBase = [[[SneakyButtonSkinnedBase alloc] init] autorelease];
    attackButtonBase.position = attackButtonPosition;
    attackButtonBase.defaultSprite = [CCSprite spriteWithFile:@"handUp.png"];
    attackButtonBase.activatedSprite = [CCSprite spriteWithFile:@"handDown.png"];
    attackButtonBase.pressSprite = [CCSprite spriteWithFile:@"handDown.png"];
    attackButtonBase.button = [[SneakyButton alloc] initWithRect:attackButtonDimensions];
    attackButton = [attackButtonBase.button retain];
    attackButton.isToggleable = NO;
    [self addChild:attackButtonBase];
    }
    
- (void)applyJoystick:(SneakyJoystick *)aJoystick toNode:(CCNode *)tempNode forTimeDelta:(float)deltaTime
    {
    CGPoint scaledVelocity = ccpMult(aJoystick.velocity, 1024.0f);
    CGPoint newPosition = ccp(tempNode.position.x + scaledVelocity.x * deltaTime, tempNode.position.y + scaledVelocity.y * deltaTime);
    [tempNode setPosition:newPosition];
    
    if (jumpButton.active == YES)
        {
        CCLOG(@"Jump button is pressed.");
        }
    if (attackButton.active == YES)
        {
        CCLOG(@"Attack button is pressed.");
        }
    }
    
#pragma mark - Update Method
- (void)update:(ccTime)deltaTime
    {
    [self applyJoystick:leftJoystick toNode:vikingSprite forTimeDelta:deltaTime];
    }


- (id)init
    {
    self = [super init];
    if (self)
        {
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        self.isTouchEnabled = YES;
        vikingSprite = [CCSprite spriteWithFile:@"sv_anim_1.png"];
        [vikingSprite setPosition:CGPointMake(screenSize.width / 2, screenSize.height * 0.17f)];
        [self addChild:vikingSprite];
        [self initJoystickAndButtons];
        [self scheduleUpdate];
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
            {
            [vikingSprite setScaleX:screenSize.width/1024.0f];
            [vikingSprite setScaleY:screenSize.height/768.0f];
            }
        }
    return self;
    }
    
        
@end
