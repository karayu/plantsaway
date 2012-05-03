//
//  InstructionsLayer.h
//  PlantsAway
//
//  Created by Brooke Griffin on 4/24/12.
//  Copyright (c) 2012 Epic. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"
#import "chipmunk.h"

@interface InstructionsLayer : CCLayer
{
    CCLabelTTF *instructionsLabel;
    CCLabelTTF *headerLabel;
    CCMenuItemImage *plant1;
    CCMenuItemImage *plant2;
    CCMenuItemImage *plant3;
}

//returns a CCScene that contains the MainLayer as the only child
+(CCScene *) scene;
//plantChosen boolean
@property int plantChosen;

//functionality to return to pause menu
- (void)startGame:(id)sender;


@end