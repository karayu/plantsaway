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
#import "MainLayer.h"


//source: http://www.iphonegametutorials.com/2010/09/07/cocos2d-menu-tutorial/
@interface SceneManager ()
+(void) go: (CCLayer *) layer;
+(CCScene *) wrap: (CCLayer *) layer;
@end

@implementation SceneManager

+(void) goMenu{

}

+(void) goPause{

}

+(void) goEndGame: (int) score {
    GameEndLayer *layer =  [GameEndLayer node];
    layer.score = score;
    [layer setScoreText];
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
