//
//  SceneManager.h
//  PlantsAway
//
//  Created by Kara Yu on 4/22/12.
//  Copyright (c) 2012 Epic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SceneManager : NSObject

extern int speed;



//functionality to manage viewing different layers
+(void)goResumeGame;
+(void)goEndGame:(int)score;
+(void)goHighScores;
+(void)goInstructions;
+(void)goNewGame:(int)boost :(int)plantType;
+(void)goPause:(int)score WithBoost:(int)boost WithTime:(int)time;
+(void)goPause;


@end
