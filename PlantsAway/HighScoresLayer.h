//
//  HighScoresLayer.h
//  PlantsAway
//
//  Created by Kara Yu on 4/22/12.
//  Copyright (c) 2012 Epic. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"
#import "chipmunk.h"
#import "HighScores.h"


@interface HighScoresLayer : CCLayer
{
    CCLabelTTF *highScoresLabel;
}

//returns the scene containing a itself
-(CCScene *) scene;

//the scores
@property (strong) NSMutableArray *scores;

//functionality of high scores layer
-(void)goBack: (id)sender;




@end