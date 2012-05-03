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
    //labels used in the view
    CCLabelTTF *gameEndLabel;
    CCLabelTTF *scoreLabel;
}

//user's score
@property int score;

//sets text to congratulate or disparage user depending on score
-(void)setScoreText;

//starts a new game
-(void)newGame:(id)sender;


@end
