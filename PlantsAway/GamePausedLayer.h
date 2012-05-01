//
//  GamePausedLayer.h
//  PlantsAway
//
//  Created by Kara Yu on 4/22/12.
//  Copyright (c) 2012 Epic. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"


@interface GamePausedLayer : CCLayer
{
    CCLabelTTF *gamePausedLabel;
}

//variables to return to pause menu & eventually resume game
@property int score;
@property int time;
@property int boost;

//functionality to allow user to view other layers
-(void)newGame:(id)sender;
-(void)highScores:(id)sender;
-(void)viewInstructions:(id)sender;
-(void)resumeGame:(id)sender;

@end
