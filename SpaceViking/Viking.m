//
//  Viking.m
//  SpaceViking
//
//  Created by Mike Pattee on 8/22/11.
//  Copyright 2011 Cordax Software LLC. All rights reserved.
//

#import "Viking.h"


@implementation Viking

@synthesize joystick;
@synthesize jumpButton;
@synthesize attackButton;

// Standing, Breathing, Walking
@synthesize breathingAnim;
@synthesize breathingMalletAnim;
@synthesize walkingAnim;
@synthesize walkingMalletAnim;

// Crouching, Standing Up, Jumping
@synthesize crouchingAnim;
@synthesize crouchingMalletAnim;
@synthesize standingUpAnim;
@synthesize standingUpMalletAnim;
@synthesize jumpingAnim;
@synthesize jumpingMalletAnim;
@synthesize afterJumpingAnim;
@synthesize afterJumpingMalletAnim;

// Punching
@synthesize leftPunchAnim;
@synthesize rightPunchAnim;
@synthesize malletPunchAnim;

// Taking Damage and Death
@synthesize phaserShockAnim;
@synthesize deathAnim;

- (void)dealloc
    {
    self.joystick = nil;
    self.jumpButton = nil;
    self.attackButton = nil;
    self.breathingAnim = nil;
    self.breathingMalletAnim = nil;
    self.walkingAnim = nil;
    self.walkingMalletAnim = nil;
    self.crouchingAnim = nil;
    self.crouchingMalletAnim = nil;
    self.standingUpAnim = nil;
    self.standingUpMalletAnim = nil;
    self.jumpingAnim = nil;
    self.jumpingMalletAnim = nil;
    self.afterJumpingAnim = nil;
    self.afterJumpingMalletAnim = nil;
    self.leftPunchAnim = nil;
    self.rightPunchAnim = nil;
    self.malletPunchAnim = nil;
    self.phaserShockAnim = nil;
    self.deathAnim = nil;
    [super dealloc];
    }
    
- (BOOL)isCarryingWeapon 
    {
    return isCarryingMallet;
    }
    
- (int)getWeaponDamage
    {
    if (isCarryingMallet)
        {
        return kVikingMalletDamage;
        }
    return kVikingFistDamage;
    }
    
- (void)applyJoystick:(SneakyJoystick *)aJoystick forTimeDelta:(float)deltaTime
    {
    CGPoint scaledVelocity = ccpMult(aJoystick.velocity, 128.0f);
    CGPoint oldPosition = [self position];
    CGPoint newPosition = ccp(oldPosition.x + scaledVelocity.x * deltaTime, oldPosition.y);
    [self setPosition:newPosition];
    if (oldPosition.x > newPosition.x) 
        {
        self.flipX = YES;
        }
    else
        {
        self.flipX = NO;
        }
    }

- (void)checkAndClampSpritePosition
    {
    if (self.characterState != kStateJumping) 
        {
        if ([self position].y > 110.0f)
            {
            [self setPosition:ccp([self position].x, 110.0f)];
            }
        }
    [super checkAndClampSpritePosition];
    }

#pragma mark -

- (void)changeState:(CharacterStates)newState
    {
    [self stopAllActions];
    id action = nil;
    id movementAction = nil;
    CGPoint newPosition;
    [self setCharacterState:newState];
    
    switch (newState)
        {
        case kStateIdle:
            if (isCarryingMallet)
                {
                [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"sv_mallet_1.png"]];
                }
            else
                {
                [self setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"sv_anim_1.png"]];
                }
            break;
        
        case kStateWalking:
            if (isCarryingMallet)
                {
                action = [CCAnimate actionWithAnimation:self.walkingMalletAnim restoreOriginalFrame:NO];
                }
            else
                {
                action = [CCAnimate actionWithAnimation:self.walkingAnim restoreOriginalFrame:NO];
                }
            break;
        
        case kStateCrouching:
            if (isCarryingMallet)
                {
                action = [CCAnimate actionWithAnimation:self.crouchingMalletAnim restoreOriginalFrame:NO];
                }
            else
                {
                action = [CCAnimate actionWithAnimation:self.crouchingAnim restoreOriginalFrame:NO];
                }
            break;
            
        case kStateStandingUp:
            if (isCarryingMallet)
                {
                action = [CCAnimate actionWithAnimation:self.standingUpMalletAnim restoreOriginalFrame:NO];
                }
            else
                {
                action = [CCAnimate actionWithAnimation:self.standingUpAnim restoreOriginalFrame:NO];
                }
            break;
        
        case kStateBreathing:
            if (isCarryingMallet)
                {
                action = [CCAnimate actionWithAnimation:self.breathingMalletAnim restoreOriginalFrame:NO];
                }
            else
                {
                action = [CCAnimate actionWithAnimation:self.breathingAnim restoreOriginalFrame:NO];
                }
            break;
            
        case kStateJumping:
            newPosition = ccp(self.screenSize.width * 0.2f, 0.0f);
            if ([self flipX] == YES)
                {
                newPosition = ccp(newPosition.x * -1.0f, 0.0f);
                }
            movementAction = [CCJumpBy actionWithDuration:0.5f position:newPosition height:160.0f jumps:1];
            if (isCarryingMallet)
                {
                // Viking jumping animation with mallet
                action = [CCSequence actions:[CCAnimate actionWithAnimation:self.crouchingMalletAnim restoreOriginalFrame:NO], [CCSpawn actions:[CCAnimate actionWithAnimation:self.jumpingMalletAnim restoreOriginalFrame:YES], movementAction, nil], [CCAnimate actionWithAnimation:self.afterJumpingMalletAnim restoreOriginalFrame:NO], nil];
                }
            else
                {
                action = [CCSequence actions:[CCAnimate actionWithAnimation:self.crouchingAnim restoreOriginalFrame:NO], [CCSpawn actions:[CCAnimate actionWithAnimation:self.jumpingAnim restoreOriginalFrame:YES], movementAction, nil], [CCAnimate actionWithAnimation:self.afterJumpingAnim restoreOriginalFrame:NO], nil];
                }
            break;
            
        case kStateAttacking:
            if (isCarryingMallet)
                {
                action = [CCAnimate actionWithAnimation:self.malletPunchAnim restoreOriginalFrame:YES];
                }
            else
                {
                if (kLeftHook == myLastPunch)
                    {
                    // Execute a right hook
                    myLastPunch = kRightHook;
                    action = [CCAnimate actionWithAnimation:self.rightPunchAnim restoreOriginalFrame:NO];
                    }
                else
                    {
                    myLastPunch = kLeftHook;
                    action = [CCAnimate actionWithAnimation:self.leftPunchAnim restoreOriginalFrame:NO];
                    }
                }
            break;
            
        case kStateTakingDamage:
            self.characterHealth = self.characterHealth - 10.0f;
            action = [CCAnimate actionWithAnimation:self.phaserShockAnim restoreOriginalFrame:YES];
            break;
        
        case kStateDead:
            action = [CCAnimate actionWithAnimation:self.deathAnim restoreOriginalFrame:NO];
            break;
            
        default:
            break;
        }
    if (action != nil)
        {
        [self runAction:action];
        }
    }
    
#pragma mark -

- (void)updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray *)listOfGameObjects
    {
    if (self.characterState == kStateDead)
        return;
        
    if ((self.characterState == kStateTakingDamage) && ([self numberOfRunningActions] > 0))
        return; // currently playing the taking damage animation
        
    // Check for collisions
    // Change this to keep the object count from querying it each time
    CGRect myBoundingBox = [self adjustedBoundingBox];
    for (GameCharacter *character in listOfGameObjects)
        {
        // this is Ole the Viking himself
        // No Need to check collision with one's self
        if ([character tag] == kVikingSpriteTagValue)
            continue;
            
        CGRect characterBox = [character adjustedBoundingBox];
        if (CGRectIntersectsRect(myBoundingBox, characterBox))
            {
            // Remove the PhaserBullet from the scene
            if ([character gameObjectType] == kEnemyTypePhaser)
                {
                [self changeState:kStateTakingDamage];
                [character changeState:kStateDead];
                }
            else if ([character gameObjectType] == kPowerUpTypeMallet)
                {
                // Update the frame to indicate Viking is carrying the mallet
                isCarryingMallet = YES;
                [self changeState:kStateIdle];
                // remove the mallet from the scene
                [character changeState:kStateDead];
                }
            else if ([character gameObjectType] == kPowerUpTypeHealth)
                {
                [self setCharacterHealth:100];
                // remove the health power-up from the scene
                [character changeState:kStateDead];
                }
            }
        }
    
    [self checkAndClampSpritePosition];
    if ((self.characterState == kStateIdle) || (self.characterState == kStateWalking) || (self.characterState == kStateCrouching) || (self.characterState == kStateStandingUp) || (self.characterState == kStateBreathing))
        {
        if (jumpButton.active)
            {
            [self changeState:kStateJumping];
            }
        else if (attackButton.active)
            {
            [self changeState:kStateAttacking];
            }
        else if ((joystick.velocity.x == 0.0f) && (joystick.velocity.y == 0.0f))
            {
            if (self.characterState == kStateCrouching)
                {
                [self changeState:kStateStandingUp];
                }
            } 
        else if (joystick.velocity.y < -0.45)
            {
            if (self.characterState != kStateCrouching)
                {
                [self changeState:kStateCrouching];
                }
            }
        else if (joystick.velocity.x != 0.0f) 
            {
            // dpad moving
            if (self.characterState != kStateWalking)
                {
                [self changeState:kStateWalking];
                }
            [self applyJoystick:self.joystick forTimeDelta:deltaTime];
            }
        }
        
    if ([self numberOfRunningActions] == 0)
        {
        // not playing an animation
        if (self.characterHealth <= 0.0f)
            {
            [self changeState:kStateDead];
            }
        else if (self.characterState == kStateIdle)
            {
            millisecondsStayingIdle = millisecondsStayingIdle + deltaTime;
            if (millisecondsStayingIdle > kVikingIdleTimer)
                {
                [self changeState:kStateBreathing];
                }
            }
        else if ((self.characterState != kStateCrouching) && (self.characterState != kStateIdle))
            {
            millisecondsStayingIdle = 0.0f;
            [self changeState:kStateIdle];
            }
        }
    }

#pragma mark -

- (CGRect)adjustedBoundingBox
    {
    // Adjust the bounding box to size of the sprite without the transparent space
    CGRect vikingBoundingBox = [self boundingBox];
    float xOffset;
    float xCropAmount = vikingBoundingBox.size.width * 0.5482f;
    float yCropAmount = vikingBoundingBox.size.height * 0.095f;
    
    if ([self flipX] == NO)
        {
        // Viking is facing to the right, back is on the left
        xOffset = vikingBoundingBox.size.width * 0.1566f;
        }
    else
        {
        xOffset = vikingBoundingBox.size.width * 0.4217f;
        }
    vikingBoundingBox = CGRectMake(vikingBoundingBox.origin.x + xOffset, vikingBoundingBox.origin.y, vikingBoundingBox.size.width - xCropAmount, vikingBoundingBox.size.height - yCropAmount);
    
    if (self.characterState == kStateCrouching)
        {
        // Shrink the bounding box to 56% of height 88 pixels on top on iPad
        vikingBoundingBox = CGRectMake(vikingBoundingBox.origin.x, vikingBoundingBox.origin.y, vikingBoundingBox.size.width, vikingBoundingBox.size.height * 0.56f);
        }
    return vikingBoundingBox;
    }
    
#pragma mark -

- (void)initAnimations
    {
    [self setBreathingAnim:[self loadPlistForAnimationWithName:@"breathingAnim" andClassName:NSStringFromClass([self class])]];
    [self setBreathingMalletAnim:[self loadPlistForAnimationWithName:@"breathingMalletAnim" andClassName:NSStringFromClass([self class])]];
    [self setWalkingAnim:[self loadPlistForAnimationWithName:@"walkingAnim" andClassName:NSStringFromClass([self class])]];
    [self setWalkingMalletAnim:[self loadPlistForAnimationWithName:@"walkingMalletAnim" andClassName:NSStringFromClass([self class])]];
    [self setCrouchingAnim:[self loadPlistForAnimationWithName:@"crouchingAnim" andClassName:NSStringFromClass([self class])]];
    [self setCrouchingMalletAnim:[self loadPlistForAnimationWithName:@"crouchingMalletAnim" andClassName:NSStringFromClass([self class])]];
    [self setStandingUpAnim:[self loadPlistForAnimationWithName:@"standingUpAnim" andClassName:NSStringFromClass([self class])]];
    [self setStandingUpMalletAnim:[self loadPlistForAnimationWithName:@"standingUpMalletAnim" andClassName:NSStringFromClass([self class])]];
    [self setJumpingAnim:[self loadPlistForAnimationWithName:@"jumpingAnim" andClassName:NSStringFromClass([self class])]];
    [self setJumpingMalletAnim:[self loadPlistForAnimationWithName:@"jumpingMalletAnim" andClassName:NSStringFromClass([self class])]];
    [self setAfterJumpingAnim:[self loadPlistForAnimationWithName:@"afterJumpingAnim" andClassName:NSStringFromClass([self class])]];
    [self setAfterJumpingMalletAnim:[self loadPlistForAnimationWithName:@"afterJumpingMalletAnim" andClassName:NSStringFromClass([self class])]];
    [self setRightPunchAnim:[self loadPlistForAnimationWithName:@"rightPunchAnim" andClassName:NSStringFromClass([self class])]];
    [self setLeftPunchAnim:[self loadPlistForAnimationWithName:@"leftPunchAnim" andClassName:NSStringFromClass([self class])]];
    [self setMalletPunchAnim:[self loadPlistForAnimationWithName:@"malletPunchAnim" andClassName:NSStringFromClass([self class])]];
    [self setPhaserShockAnim:[self loadPlistForAnimationWithName:@"phaserShockAnim" andClassName:NSStringFromClass([self class])]];
    [self setDeathAnim:[self loadPlistForAnimationWithName:@"deathAnim" andClassName:NSStringFromClass([self class])]];
    }
    
- (id)init
    {
    self = [super init];
    if (self)
        {
        self.joystick = nil;
        self.jumpButton = nil;
        self.attackButton = nil;
        self.gameObjectType = kVikingType;
        myLastPunch = kRightHook;
        millisecondsStayingIdle = 0.0f;
        isCarryingMallet = NO;
        [self initAnimations];
        }
        
    return self;
    }
@end
