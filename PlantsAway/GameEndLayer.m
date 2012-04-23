//
//  GameEndLayer.m
//  PlantsAway
//
//  Created by Kara Yu on 4/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameEndLayer.h"
#import "cocos2d.h"
#import "SceneManager.h"


@implementation GameEndLayer
{
    GameEndLayer *gameEndLayer;
}

//@synthesize gameEndLayer;

-(id) init
{
	//always call "super" init
	if( (self=[super init])) 
    {
		
        //Create and add the score label as a child.
        scoreLabel = [CCLabelTTF labelWithString:@"Congratulations!  Your score was 0 points" fontName:@"Marker Felt" fontSize:24];
        scoreLabel.position = ccp(160, 440 ); 
        [self addChild:scoreLabel];
        
        //Create and add pause button as a child
        CCMenuItem *pauseMenuItem = [CCMenuItemImage 
                                     itemFromNormalImage: @"pause.png" selectedImage:@"pause.png" 
                                     target:self selector:@selector(pauseTapped)];
        pauseMenuItem.position = ccp(350, 530);
        
        
        //CCLabel *titleCenterTop = [CCLabel labelWithString:@"How to build a..." fontName:@"Marker Felt" fontSize:26];
        //CCLabel *titleCenterBottom = [CCLabel labelWithString:@"Part 1" fontName:@"Marker Felt" fontSize:48];
        
        CCMenuItemFont *startNew = [CCMenuItemFont itemFromString:@"New Game" target:self selector: @selector(newGame:)];
        startNew.position = ccp(350, 530);
        [self addChild:startNew];
        
    
        CCMenu *menu = [CCMenu menuWithItems:startNew, nil];
        
        menu.position = ccp(160, 200);
        [menu alignItemsVerticallyWithPadding: 40.0f];
        [self addChild:menu z: 1];
        


    }
    return self;

}


- (void)newGame:(id)sender{
	[SceneManager goMenu];
}

- (void)onCredits:(id)sender{
	[SceneManager goMenu];
}
@end


