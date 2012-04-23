//
//  GameEndLayer.h
//  PlantsAway
//
//  Created by Kara Yu on 4/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CCLayer.h"

//When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

//Importing Chipmunk headers
#import "chipmunk.h"

@interface GameEndLayer : CCLayer
{
    CCLabelTTF *gameEndLabel;
    CCLabelTTF *scoreLabel;
}


@property int score;
- (void) setScoreText;


@end
