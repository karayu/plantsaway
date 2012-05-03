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


//pauses game while keeping track of the score and time left. called from the pause button in main layer
+(void)goPause
{
    [[CCDirector sharedDirector] pushScene: [GamePausedLayer scene]];
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

//resumes game when user has paused
+(void)goResumeGame
{
    [[CCDirector sharedDirector] popScene];

}


//creates a new game
+(void)goNewGame :(int)boost :(int)plant
{
    MainLayer *layer = [MainLayer node];
    [layer initBoost: boost];
    [layer setUpPlant:plant];
    
    [[CCDirector sharedDirector] replaceScene: [layer scene]];
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
    //adds the high scores layer scene to the scene stack
    [[CCDirector sharedDirector] pushScene: [HighScoresLayer scene]];
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
