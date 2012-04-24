//
//  InstructionsLayer.h
//  PlantsAway
//
//  Created by Brooke Griffin on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"
#import "chipmunk.h"

@interface InstructionsLayer : CCLayer
{
    CCLabelTTF *instructionsLabel;
}

@property int score;
@property int time;


@end