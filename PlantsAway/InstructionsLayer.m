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

/*-(id)init
{
	//always call "super" init
	if((self=[super init])) 
    {
        //create instructions as string
        NSString *instructions = [[NSString alloc] init];
        instructions = @"As a cranky old lady, you want to hit as many hoodlums as you can with your many potted plants. Tap your finger wherever you want the old lady to move and tap the plant to drop it. You get points for hitting the hoodlums but lose points for striking innocent passersby!";
        
        //create and add the instructions label to the layer
        instructionsLabel = [CCLabelTTF labelWithString:instructions dimensions:CGSizeMake(300, 300) alignment:UITextAlignmentCenter fontName:@"Marker Felt" fontSize:18 ];
        instructionsLabel.position = ccp( 160, 290 ); 
        [self addChild:instructionsLabel];

        //create and add the instructions label to the layer
        headerLabel = [CCLabelTTF labelWithString:@"Choose your boost:" dimensions:CGSizeMake(300, 100) alignment:UITextAlignmentCenter fontName:@"Marker Felt" fontSize:24 ];
        headerLabel.position = ccp( 160, 180 );
        [self addChild:headerLabel];
        
        //button for returning to pause menu
        //CCMenuItemFont *goBack = [CCMenuItemFont itemFromString:@"back" target:self selector: @selector(pauseMenu:)];
        
        CCMenuItem *plant1 = [CCMenuItemImage itemFromNormalImage:@"leaf.png" 
                                                         selectedImage:@"leaf.png"];
        
        CCMenuItem *plant2 = [CCMenuItemImage itemFromNormalImage:@"flower.png"
                                                         selectedImage: @"flower.png"];
        
        CCMenuItem *plant3 = [CCMenuItemImage itemFromNormalImage:@"shrub.png"
                                                         selectedImage: @"shrub.png"];
        
        //create toggle menu for plants
        CCMenuItemToggle *toggleMenu = [CCMenuItemToggle itemWithTarget:self selector:@selector(startDouble:) items: plant1,plant2,plant3,nil];
        CCMenu *plantMenu = [CCMenu menuWithItems:toggleMenu, nil];
        [plantMenu alignItemsVertically];
        plantMenu.position = ccp( 160, 300 );
        plantMenu.tag = 1;
        [self addChild:plantMenu  z:1];
        
        //create teleportation button
        CCMenuItemImage *teleportation = [CCMenuItemImage itemFromNormalImage:@"boost0.png"
                                                             selectedImage: @"boost0_selected.png"
                                                                    target:self
                                                                  selector:@selector(startTeleport:)];
        //create double speed button
        CCMenuItemImage *doubleSpeed = [CCMenuItemImage itemFromNormalImage:@"boost1.png"
                                                                selectedImage: @"boost1_selected.png"
                                                                       target:self
                                                                     selector:@selector(startDouble:)];
        
        //create no boost menu button
        CCMenuItemImage *noBoost = [CCMenuItemImage itemFromNormalImage:@"boost2.png"
                                                              selectedImage: @"boost2_selected.png"
                                                                     target:self
                                                                   selector:@selector(startNone:)];
        
        
        //create back button menu to return to pause menu
        CCMenu *menu = [CCMenu menuWithItems:doubleSpeed,teleportation,noBoost,nil];
        menu.position = ccp( 160, 100 );
        [menu alignItemsVerticallyWithPadding: 12.0f];
        [self addChild:menu z: 1];
    }
    
    return self;
}*/


//NOT REAL INIT
-(id)init
{
    if((self=[super init]))
    {
        
        //draw rectangle background
        CCSprite *rectangle = [CCSprite spriteWithFile: @"rect.png"];
        rectangle.position = ccp( 160, 240 );
        [self addChild:rectangle];
        [rectangle setScale:0.34];
        
        //create plant menu items
        CCMenuItem *plant1 = [CCMenuItemImage itemFromNormalImage:@"leaf.png" 
                                                    selectedImage:@"leaf_selected.png"
                                                           target:self
                                                         selector:@selector(chooseMyPlant:)];
        
        CCMenuItem *plant2 = [CCMenuItemImage itemFromNormalImage:@"flower.png"
                                                    selectedImage: @"flower_selected.png"
                                                           target:self
                                                         selector:@selector(chooseMyPlant:)];
        
        CCMenuItem *plant3 = [CCMenuItemImage itemFromNormalImage:@"shrub.png"
                                                    selectedImage: @"shrub_selected.png"
                                                           target:self
                                                         selector:@selector(chooseMyPlant:)];                              
    
        //set tags for items
        plant1.tag = 1;
        plant2.tag = 2;
        plant3.tag = 3;
        
        //create menu with these as buttons
        CCMenu *bottomMenu = [CCMenu menuWithItems:plant1,plant2,plant3,nil];
        bottomMenu.position = ccp( 160,240 );
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
        teleportation.tag = 0;
        doubleSpeed.tag = 1;
        noBoost.tag = 2;
        
        //adjust scale of super big buttons
        [teleportation setScale:.8];
        [doubleSpeed setScale:.8];
        [noBoost setScale:.8];
        
        //create back button menu to return to pause menu
        CCMenu *menu = [CCMenu menuWithItems:doubleSpeed,teleportation,noBoost,nil];
        menu.position = ccp( 160, 100 );
        [menu alignItemsVerticallyWithPadding: 9.0f];
        [self addChild:menu z:1];
    }
    
    return self;
}

//choose yer plant!
-(void)chooseMyPlant:(id)sender
{
    CCMenuItem *item = (CCMenuItem *)sender;
    self.plantChosen = item.tag;
    NSLog(@"%d", self.plantChosen);
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

