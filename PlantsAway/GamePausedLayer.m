//
//  GamePausedLayer.m
//  PlantsAway
//
//  Created by Kara Yu on 4/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GamePausedLayer.h"
#import "cocos2d.h"
#import "SceneManager.h"

@implementation GamePausedLayer

@synthesize score, time;

-(id) init
{
	//always call "super" init
	if( (self=[super init])) 
    {
        //Create and add the title for the layer
        gamePausedLabel = [CCLabelTTF labelWithString:@"Game Paused" dimensions:CGSizeMake(200, 200) alignment:UITextAlignmentCenter fontName:@"Marker Felt" fontSize:35 ];
        gamePausedLabel.position = ccp(160, 300 ); 
        [self addChild:gamePausedLabel];
        
        //button for resuming game
        CCMenuItemFont *resumeGame = [CCMenuItemFont itemFromString:@"Resume Game" target:self selector: @selector(resumeGame:)];
        
        //button for starting a new game
        CCMenuItemFont *startNew = [CCMenuItemFont itemFromString:@"New Game" target:self selector: @selector(newGame:)];
        
        //creates a menu with the two buttons
        CCMenu *menu = [CCMenu menuWithItems: resumeGame, startNew, nil];
        
        menu.position = ccp(160, 200);
        [menu alignItemsVerticallyWithPadding: 40.0f];
        [self addChild:menu z: 2];
        
        
        
    }
    return self;
}

//called by the new game button
- (void)newGame:(id)sender{
	[SceneManager goNewGame];
}

//called by the resume game button
- (void)resumeGame:(id)sender{
	[SceneManager goResumeGame: score WithTime: time];
}


@end
