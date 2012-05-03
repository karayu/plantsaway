//
//  InstructionsLayer.m
//  PlantsAway
//
//  Created by Brooke Griffin on 4/24/12.
//  Copyright (c) 2012 Epic. All rights reserved.
//

#import "InstructionsLayer.h"
#import "cocos2d.h"
#import "SceneManager.h"

@implementation InstructionsLayer

@synthesize plantChosen;

+(CCScene *) scene
{
	//initialize scene
	CCScene *scene = [CCScene node];
	
	//initialize layer
    InstructionsLayer *layer =  [InstructionsLayer node];
    
	//add layer as a child to scene
	[scene addChild: layer];
	
	//return the scene
	return scene;
}

-(id)init
{
    if((self=[super init]))
    {
        //create instructions as string
        NSString *instructions = [[NSString alloc] init];
        instructions = @"As a cranky old lady, you want to hit as many hoodlums as you can with your many potted plants. Tap your finger wherever you want the old lady to move and tap the plant to drop it. You get points for hitting the hoodlums but lose points for striking innocent passersby!";
        
        //create and add the instructions label to the layer
        instructionsLabel = [CCLabelTTF labelWithString:instructions dimensions:CGSizeMake(300, 300) alignment:UITextAlignmentCenter fontName:@"Marker Felt" fontSize:18 ];
        instructionsLabel.position = ccp( 160, 300 ); 
        [self addChild:instructionsLabel];
        
        //create and add the instructions label to the layer
        headerLabel = [CCLabelTTF labelWithString:@"Choose a plant and a boost:" dimensions:CGSizeMake(300, 100) alignment:UITextAlignmentCenter fontName:@"Marker Felt" fontSize:24 ];
        headerLabel.position = ccp( 160, 230 );
        [self addChild:headerLabel];
        
        //draw rectangle background
        CCSprite *rectangle = [CCSprite spriteWithFile: @"rect.png"];
        rectangle.position = ccp( 160, 200 );
        [self addChild:rectangle];
        [rectangle setScale:0.34];
        
        //create plant menu items
        plant1 = [CCMenuItemImage itemFromNormalImage:@"leaf.png" 
                                        selectedImage:@"leaf_selected.png"
                                               target:self
                                             selector:@selector(chooseMyPlant:)];
        
        plant2 = [CCMenuItemImage itemFromNormalImage:@"flower.png"
                                        selectedImage: @"flower_selected.png"
                                               target:self
                                             selector:@selector(chooseMyPlant:)];
        
        plant3 = [CCMenuItemImage itemFromNormalImage:@"shrub.png"
                                        selectedImage: @"shrub_selected.png"
                                               target:self
                                             selector:@selector(chooseMyPlant:)];                              
        
        //set tags for items
        plant1.tag = 1;
        plant2.tag = 2;
        plant3.tag = 3;
        
        //create menu with these as buttons
        CCMenu *bottomMenu = [CCMenu menuWithItems:plant1,plant2,plant3,nil];
        bottomMenu.position = ccp( 160,200 );
        [bottomMenu alignItemsHorizontally];
        [self addChild: bottomMenu z: 10];
        
        
        //create teleportation button
        CCMenuItemImage *teleportation = [CCMenuItemImage itemFromNormalImage:@"boost0.png"
                                                                selectedImage:@"boost0_selected.png"
                                                                       target:self
                                                                     selector:@selector(initializeGame:)];
        //create double speed button
        CCMenuItemImage *doubleSpeed = [CCMenuItemImage itemFromNormalImage:@"boost1.png"
                                                              selectedImage:@"boost1_selected.png"
                                                                     target:self
                                                                   selector:@selector(initializeGame:)];
        
        //create no boost menu button
        CCMenuItemImage *noBoost = [CCMenuItemImage itemFromNormalImage:@"boost2.png"
                                                          selectedImage:@"boost2_selected.png"
                                                                 target:self
                                                               selector:@selector(initializeGame:)];
        //set tags for items
        teleportation.tag = 1000;
        doubleSpeed.tag = 2;
        noBoost.tag = 1;
        
        //adjust scale of super big buttons
        [teleportation setScale:.8];
        [doubleSpeed setScale:.8];
        [noBoost setScale:.8];
        
        //create back button menu to return to pause menu
        CCMenu *menu = [CCMenu menuWithItems:doubleSpeed,teleportation,noBoost,nil];
        menu.position = ccp( 160, 70 );
        [menu alignItemsVerticallyWithPadding: 6.0f];
        [self addChild:menu z:1];
    }
    
    return self;
}

//choose yer plant!
-(void)chooseMyPlant:(id)sender
{
    //get the tagged number per plant
    CCMenuItem *item = (CCMenuItem *)sender;
    self.plantChosen = item.tag;
    
    //change opacity display based on plant selection
    switch(item.tag)
    {
        case 1:
            plant1.opacity = 255;
            plant2.opacity = 50;
            plant3.opacity = 50;
            break;
        case 2:
            plant1.opacity = 50;
            plant2.opacity = 255;
            plant3.opacity = 50;
            break;
        case 3:
            plant1.opacity = 50;
            plant2.opacity = 50;
            plant3.opacity = 255;
            break;
    }
}

//alert if plant has not been chosen
-(void)alertPlantNeeded
{
    UIAlertView *uNeedPlantz = [[UIAlertView alloc] initWithTitle: @"FIRST" message:@"pick a plant!"  delegate: self cancelButtonTitle: @"OK" otherButtonTitles: nil];
    [uNeedPlantz show];
}

//start game with selected boost and speed
-(void)initializeGame:(id)sender
{
    CCMenuItem *item = (CCMenuItem *)sender;
	if (self.plantChosen)
        [SceneManager goNewGame:item.tag :self.plantChosen];
    else
        [self alertPlantNeeded];
}

@end

