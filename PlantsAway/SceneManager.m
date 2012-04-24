//
//  SceneManager.m
//  PlantsAway
//
//  Created by Kara Yu on 4/22/12.
//  Copyright (c) 2012 Epic. All rights reserved.
//

#import "cocos2d.h"
#import "chipmunk.h"
#import "SceneManager.h"
#import "GameEndLayer.h"
#import "GamePausedLayer.h"
#import "HighScoresLayer.h"
#import "InstructionsLayer.h"
#import "MainLayer.h"


@interface SceneManager ()
+(void)go:(CCLayer *)layer;
+(CCScene *)wrap:(CCLayer *)layer;
@end


@implementation SceneManager

static int timeLeft = 100;
static int currentScore = 100;

//returns to pause menu (called by high scores or instructions)
+(void)goPause
{
    //creates a game paused layer that know the score and time left
    GamePausedLayer *layer = [GamePausedLayer node];
    layer.score = currentScore;
    layer.time = timeLeft;
    
    [SceneManager go: layer];
}

//pauses game while keeping track of the score and time left. called from the pause button in main layer
+(void)goPause:(int)score WithTime:(int)time 
{
    //creates a game paused layer that know the score and time left
    GamePausedLayer *layer = [GamePausedLayer node];
    layer.score = score;
    layer.time = time;
    
    timeLeft = time;
    currentScore = score;
    [SceneManager go: layer];
}

//ends the game and tells the user the score. called when time runs out
+(void)goEndGame:(int)score 
{
    //create a game end layer
    GameEndLayer *layer =  [GameEndLayer node];
    layer.score = score;
    [layer setScoreText];
	[SceneManager go: layer];
}

+(void)goResumeGame
{
    MainLayer *layer =  [MainLayer node];
    layer.score = currentScore;
    layer.time = timeLeft;
    [layer updateScore];
    [layer updateTime];
	[SceneManager go: layer];
}

//resumes game play by restoring the score and time left after pause layer.  called by pause layer
+(void)goResumeGame: (int)score WithTime: (int)time 
{
    MainLayer *layer =  [MainLayer node];
    layer.score = score;
    layer.time = time;
    [layer updateScore];
    [layer updateTime];
	[SceneManager go: layer];
}

//creates a new game
+(void)goNewGame 
{
    MainLayer *layer = [MainLayer node];
	[SceneManager go: layer];
}

//shows high scores layer
+(void)goInstructions 
{
    InstructionsLayer *layer =  [InstructionsLayer node];
	[SceneManager go: layer];
}

//shows high scores layer
+(void)goHighScores 
{
    HighScoresLayer *layer =  [HighScoresLayer node];
	[SceneManager go: layer];
}

//source: http://www.iphonegametutorials.com/2010/09/07/cocos2d-menu-tutorial/
//goes to the layer passed
+(void)go:(CCLayer *)layer
{
	CCDirector *director = [CCDirector sharedDirector];
	CCScene *newScene = [SceneManager wrap:layer];
	if ([director runningScene]) {
		[director replaceScene: newScene];
	}else {
		[director runWithScene:newScene];
	}
}

//renders the new layer
+(CCScene *)wrap:(CCLayer *)layer
{
	CCScene *newScene = [CCScene node];
	[newScene addChild: layer];
	return newScene;
}

@end
