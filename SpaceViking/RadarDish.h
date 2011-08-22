//
//  RadarDish.h
//  SpaceViking
//
//  Created by Mike Pattee on 8/22/11.
//  Copyright 2011 Cordax Software LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameCharacter.h"

@interface RadarDish : GameCharacter 
    {
    GameCharacter *vikingCharacter;
    }

@property (nonatomic, retain) CCAnimation *tiltingAnim;
@property (nonatomic, retain) CCAnimation *transmittingAnim;
@property (nonatomic, retain) CCAnimation *takingAHitAnim;
@property (nonatomic, retain) CCAnimation *blowingUpAnim;

@end
