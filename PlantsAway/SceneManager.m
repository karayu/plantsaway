//
//  SceneManager.m
//  PlantsAway
//
//  Created by Kara Yu on 4/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SceneManager.h"
//When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

//Importing Chipmunk headers
#import "chipmunk.h"
#import "GameEndLayer.h"
#import "GamePausedLayer.h"
#import "MainLayer.h"


@interface SceneManager ()
+(void) go: (CCLayer *) layer;
+(CCScene *) wrap: (CCLayer *) layer;
@end

@implementation SceneManager


//pauses game while keeping track of the score and time left. called from the pause button in main layer
+(void) goPause: (int) score WithTime:(int)time {
    //creates a game paused layer that know the score and time left
    GamePausedLayer *layer = [GamePausedLayer node];
    layer.score = score;
    layer.time = time;
    [SceneManager go: layer];
}

//ends the game and tells the user the score. called when time runs out
+(void) goEndGame: (int) score {
    //create a game end layer
    GameEndLayer *layer =  [GameEndLayer node];
    layer.score = score;
    [layer setScoreText];
	[SceneManager go: layer];
}

//resumes game play by restoring the score and time left after pause layer.  called by pause layer
+(void) goResumeGame: (int) score WithTime: (int) time {
    MainLayer *layer =  [MainLayer node];
    layer.score = score;
    layer.time = time;
    [layer updateScore];
    [layer updateTime];
	[SceneManager go: layer];
}

//creates a new game
+(void) goNewGame {
    MainLayer *layer = [MainLayer node];
	[SceneManager go: layer];
}

//source: http://www.iphonegametutorials.com/2010/09/07/cocos2d-menu-tutorial/
//goes to the layer passed
+(void) go: (CCLayer *) layer{
	CCDirector *director = [CCDirector sharedDirector];
	CCScene *newScene = [SceneManager wrap:layer];
	if ([director runningScene]) {
		[director replaceScene: newScene];
	}else {
		[director runWithScene:newScene];
	}
}

+(CCScene *) wrap: (CCLayer *) layer{
	CCScene *newScene = [CCScene node];
	[newScene addChild: layer];
	return newScene;
}

@end
