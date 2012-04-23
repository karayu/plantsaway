//
//  GamePausedLayer.h
//  PlantsAway
//
//  Created by Kara Yu on 4/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"


@interface GamePausedLayer : CCLayer
{
    CCLabelTTF *gamePausedLabel;
}

@property int score;
@property int time;

@end
