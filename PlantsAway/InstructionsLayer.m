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


-(id)init
{
	//always call "super" init
	if((self=[super init])) 
    {
        //create instructions as string
        NSString *instructions = [[NSString alloc] init];
        instructions = @"As a cranky old lady, you want to hit as many hoodlums as you can with your many potted plants.  Tap your finger wherever you want the old lady to move and swipe upward to slingshot the plant downward.  You get points for hitting the hoodlums but lose points for striking innocent passersby!";
        
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
        
        // Create some menu items
        CCMenuItemImage *teleportation = [CCMenuItemImage itemFromNormalImage:@"boost0.png"
                                                             selectedImage: @"boost0_selected.png"
                                                                    target:self
                                                                  selector:@selector(startTeleport:)];
        // Create some menu items
        CCMenuItemImage *doubleSpeed = [CCMenuItemImage itemFromNormalImage:@"boost1.png"
                                                                selectedImage: @"boost1_selected.png"
                                                                       target:self
                                                                     selector:@selector(startDouble:)];
        
        // Create some menu items
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
}

//go back to pause menu
-(void)startTeleport:(id)sender
{
	[SceneManager goNewGame:0];
}

//go back to pause menu
-(void)startDouble:(id)sender
{
	[SceneManager goNewGame:1];
}

//go back to pause menu
-(void)startNone:(id)sender
{
	[SceneManager goNewGame:2];
}


@end

