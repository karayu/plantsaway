//
//  GamePausedLayer.m
//  PlantsAway
//
//  Created by Kara Yu on 4/22/12.
//  Copyright (c) 2012 Epic. All rights reserved.
//

#import "GamePausedLayer.h"
#import "cocos2d.h"
#import "SceneManager.h"

@implementation GamePausedLayer


+(CCScene *) scene
{
	//initialize scene
	CCScene *scene = [CCScene node];
	
	//initialize layer
	GamePausedLayer *layer = [GamePausedLayer node];
    
	//add layer as a child to scene
	[scene addChild: layer];
	
	//return the scene
	return scene;
}

-(id)init
{
	//always call "super" init
	if((self=[super init])) 
    {
        //Create and add the title for the layer
        gamePausedLabel = [CCLabelTTF labelWithString:@"Game Paused" dimensions:CGSizeMake(300, 200) alignment:UITextAlignmentCenter fontName:@"Marker Felt" fontSize:42 ];
        gamePausedLabel.position = ccp( 160, 350 ); 
        [self addChild:gamePausedLabel];
        
        //create menu buttons for user to view other layers
        CCMenuItemFont *resumeGame = [CCMenuItemFont itemFromString:@"Resume Game" target:self selector: @selector(resumeGame:)];
        CCMenuItemFont *startNew = [CCMenuItemFont itemFromString:@"New Game" target:self selector: @selector(newGame:)];
        CCMenuItemFont *highScores = [CCMenuItemFont itemFromString:@"High Scores" target:self selector: @selector(highScores:)];
        
        //creates a menu with the buttons listed above
        CCMenu *menu = [CCMenu menuWithItems: resumeGame, startNew, highScores, nil];
        menu.position = ccp( 160, 200 );
        [menu alignItemsVerticallyWithPadding: 40.0f];
        [self addChild:menu z: 2];
    }
    return self;
}

//called by the new game button
-(void)newGame:(id)sender
{
	[SceneManager goInstructions];
}

//called by the high scores button
-(void)highScores:(id)sender
{
	[SceneManager goHighScores];
}

//called by the resume game button
-(void)resumeGame:(id)sender
{    
    [SceneManager goResumeGame];
}

@end
