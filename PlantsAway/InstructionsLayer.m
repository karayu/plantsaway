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

@synthesize score, time;

-(id)init
{
	//always call "super" init
	if((self=[super init])) 
    {
        //create instructions as string
        NSString *instructions = [[NSString alloc] init];
        instructions = @"As a cranky old lady, you want to hit as many hoodlums as you can with your many potted plants.  Tap your finger wherever you want the old lady to move and swipe upward to slingshot the plant downward.  You get points for hitting the hoodlums but lose points for striking innocent passersby!";
        
        //create and add the instructions label to the layer
        instructionsLabel = [CCLabelTTF labelWithString:instructions dimensions:CGSizeMake(200, 400) alignment:UITextAlignmentCenter fontName:@"Marker Felt" fontSize:18 ];
        instructionsLabel.position = ccp( 160, 200 ); 
        [self addChild:instructionsLabel];
        
        //button for returning to pause menu
        CCMenuItemFont *goBack = [CCMenuItemFont itemFromString:@"back" target:self selector: @selector(pauseMenu:)];
        
        //create back button menu to return to pause menu
        CCMenu *menu = [CCMenu menuWithItems:goBack, nil];
        menu.position = ccp( 160, 50 );
        [menu alignItemsVerticallyWithPadding: 40.0f];
        [self addChild:menu z: 1];
    }
    
    return self;
}

//go back to pause menu
-(void)pauseMenu:(id)sender
{
	[SceneManager goPause:score WithTime: time];
}


@end

