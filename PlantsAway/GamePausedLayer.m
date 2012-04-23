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
        //Create and add the score label as a child.
        
        
        gamePausedLabel = [CCLabelTTF labelWithString:@"Game Paused" dimensions:CGSizeMake(200, 200) alignment:UITextAlignmentCenter fontName:@"Marker Felt" fontSize:35 ];
        gamePausedLabel.position = ccp(160, 300 ); 
        [self addChild:gamePausedLabel];
        
        
        CCMenuItemFont *resumeGame = [CCMenuItemFont itemFromString:@"Resume Game" target:self selector: @selector(resumeGame:)];
        
        CCMenuItemFont *startNew = [CCMenuItemFont itemFromString:@"New Game" target:self selector: @selector(newGame:)];
        
        
        CCMenu *menu = [CCMenu menuWithItems: resumeGame, startNew, nil];
        
        menu.position = ccp(160, 200);
        [menu alignItemsVerticallyWithPadding: 40.0f];
        [self addChild:menu z: 1];
        
        
        
    }
    return self;
}

- (void)newGame:(id)sender{
	[SceneManager goNewGame];
}

- (void)resumeGame:(id)sender{
	[SceneManager goResumeGame: score WithTime: time];
}


@end
