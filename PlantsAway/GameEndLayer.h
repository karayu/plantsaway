//
//  GameEndLayer.h
//  PlantsAway
//
//  Created by Kara Yu on 4/22/12.
//  Copyright (c) 2012 Epic. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"
#import "chipmunk.h"

@interface GameEndLayer : CCLayer
{
    CCLabelTTF *gameEndLabel;
    CCLabelTTF *scoreLabel;
}

//variables to show user their score
@property int score;

//functionality for game end layer
-(void)setScoreText;
-(void)newGame:(id)sender;


@end
