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


//source: http://www.iphonegametutorials.com/2010/09/07/cocos2d-menu-tutorial/
@interface SceneManager ()
+(void) go: (CCLayer *) layer;
+(CCScene *) wrap: (CCLayer *) layer;
@end

@implementation SceneManager

+(void) goMenu{

}

+(void) goPause: (int) score WithTime:(int)time {
    GamePausedLayer *layer = [GamePausedLayer node];
    layer.score = score;
    layer.time = time;
    [SceneManager go: layer];
}

+(void) goEndGame: (int) score {
    GameEndLayer *layer =  [GameEndLayer node];
    layer.score = score;
    [layer setScoreText];
	[SceneManager go: layer];
}

+(void) goResumeGame: (int) score WithTime: (int) time {
    MainLayer *layer =  [MainLayer node];
    layer.score = score;
    layer.time = time;
    [layer updateScore];
    [layer updateTime];
	[SceneManager go: layer];
}

+(void) goNewGame {
    CCLayer *layer = [MainLayer node];
	[SceneManager go: layer];
}


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
