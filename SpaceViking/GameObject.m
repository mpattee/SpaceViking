//
//  GameObject.m
//  SpaceViking
//
//  Created by Mike Pattee on 8/22/11.
//  Copyright 2011 Cordax Software LLC. All rights reserved.
//

#import "GameObject.h"


@implementation GameObject
@synthesize reactsToScreenBoundaries;
@synthesize screenSize;
@synthesize isActive;
@synthesize gameObjectType;

- (id)init
    {
    self = [super init];
    if (self)
        {
        CCLOG(@"GameObject init");
        self.screenSize = [[CCDirector sharedDirector] winSize];
        self.isActive = YES;
        self.gameObjectType = kObjectTypeNone;
        }
    return self;
    }

- (void)changeState:(CharacterStates)newState
    {
    CCLOG(@"GameObject->changeState method should be overridden");
    }
    
- (void)updateStateWithDeltaTime:(ccTime)deltaTime andListOfGameObjects:(CCArray *)listOfGameObjects
    {
    CCLOG(@"updateStateWithDeltaTime:andListOfGameObjects: should be overridden");
    }
    
- (CGRect)adjustedBoundingBox
    {
    CCLOG(@"GameObject adjustedBoundingBox should be overridden");
    return [self boundingBox];
    }
    
- (CCAnimation *)loadPlistForAnimationWithName:(NSString *)animationName andClassName:(NSString *)className
    {
    CCAnimation *animationToReturn = nil;
    NSString *fullFileName = [NSString stringWithFormat:@"%@.plist", className];
    NSString *plistPath = nil;
    
    // 1: Get the path to the plist file
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:fullFileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
        {
        plistPath = [[NSBundle mainBundle] pathForResource:className ofType:@"plist"];
        }
    
    // 2: Read in the plist file
    NSDictionary *plistDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    // 3: If the plistDictionary was nil, the file was not found.
    if (plistDictionary == nil)
        {
        CCLOG(@"Error reading plist: %@.plist", className);
        return nil; // no plist dictionary or file found
        }
    
    // 4: Get just the mini-dictionary for this animation
    NSDictionary *animationSettings = [plistDictionary objectForKey:animationName];
    if (animationSettings == nil)
        {
        CCLOG(@"Could not locate animation with name :%@", animationName);
        return nil;
        }
    
    // 5: Get the delay value for the animation
    float animationDelay = [[animationSettings objectForKey:@"delay"] floatValue];
    animationToReturn = [CCAnimation animation];
    [animationToReturn setDelay:animationDelay];
    
    // 6: Add the frames to the animation
    NSString *animationFramePrefix = [animationSettings objectForKey:@"filenamePrefix"];
    NSString *animationFrames = [animationSettings objectForKey:@"animationFrames"];
    NSArray *animationFrameNumbers = [animationFrames componentsSeparatedByString:@","];
    
    for (NSString *frameNumber in animationFrameNumbers)
        {
        NSString *frameName = [NSString stringWithFormat:@"%@%@.png", animationFramePrefix, frameNumber];
        [animationToReturn addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName]];
        }
        
    [[CCAnimationCache sharedAnimationCache] addAnimation:animationToReturn name:animationName];
    
    return animationToReturn;
    }
    
@end
