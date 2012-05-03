//
//  SceneManager.h
//  PlantsAway
//
//  Created by Kara Yu on 4/22/12.
//  Copyright (c) 2012 Epic. All rights reserved.
//

#import <Foundation/Foundation.h>

//manages most switching between scenes
@interface SceneManager : NSObject

//class methods so everyone can call them
+(void)goPause;
+(void)goEndGame:(int)score;
+(void)goResumeGame;
+(void)goNewGame:(int)boost :(int)plantType;
+(void)goInstructions;
+(void)goHighScores;

//switching and showing layers
+(void)go:(CCLayer *)layer;
+(CCScene *)wrap:(CCLayer *)layer;

@end
