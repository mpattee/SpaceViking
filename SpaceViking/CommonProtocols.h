//
//  CommonProtocols.h
//  SpaceViking
//
//  Created by Mike Pattee on 8/22/11.
//  Copyright 2011 Cordax Software LLC. All rights reserved.
//

typedef enum 
    {
    kDirectionLeft,
    kDirectionRight,
    } PhaserDirection;
    
typedef enum
    {
    kStateSpawning,
    kStateIdle,
    kStateCrouching,
    kStateStandingUp,
    kStateWalking,
    kStateAttacking,
    kStateJumping,
    kStateBreathing,
    kStateTakingDamage,
    kStateDead,
    kStateTraveling,
    kStateRotating,
    kStateDrilling,
    kStateAfterJumping,
    } CharacterStates;
    
typedef enum
    {
    kObjectTypeNone,
    kPowerUpTypeHealth,
    kPowerUpTypeMallet,
    kEnemyTypeRadarDish,
    kEnemyTypeSpaceCargoShip,
    kEnemyTypeAlienRobot,
    kEnemyTypePhaser,
    kVikingType,
    kSkullType,
    kRockType,
    kMeterorType,
    kFrozenVikingType,
    kIceType,
    kLongBlockType,
    kCartType,
    kSpikesType,
    kDiggerType,
    kGroundType
    } GameObjectType;
    

#import <Foundation/Foundation.h>

@protocol GameplayLayerDelegate
- (void)createObjectOfType:(GameObjectType)objectType withHealth:(int)initialHealth atLocation:(CGPoint)spawnLocation withZValue:(int)ZValue;
- (void)createPhaserWithDirection:(PhaserDirection)phaserDirection andPosition:(CGPoint)spawnPosition;
@end
