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
}


//functionality to return to pause menu
- (void)pauseMenu:(id)sender;

@end