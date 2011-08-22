//
//  GameCharacter.h
//  SpaceViking
//
//  Created by Mike Pattee on 8/22/11.
//  Copyright 2011 Cordax Software LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameObject.h"

@interface GameCharacter : GameObject 
    {
    }
    
@property (readwrite) int characterHealth;
@property (readwrite) CharacterStates characterState;
    
- (void)checkAndClampSpritePosition;
- (int)getWeaponDamage;

@end
