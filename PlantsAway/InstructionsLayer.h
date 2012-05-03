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
    //components for view
    CCLabelTTF *instructionsLabel;
    CCLabelTTF *headerLabel;
    CCMenuItemImage *plant1;
    CCMenuItemImage *plant2;
    CCMenuItemImage *plant3;
}


//plantChosen boolean
@property int plantChosen;

//returns a CCScene that contains an InstructionsLayer as the only child
+(CCScene *) scene;

//allows user to choose plant
-(void)chooseMyPlant:(id)sender;

//alerts user if they haven't chosen a plant
-(void)alertPlantNeeded;

//starts the game, passes the plant chosen
-(void)initializeGame:(id)sender;




@end