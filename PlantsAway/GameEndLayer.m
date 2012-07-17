//
//  GameEndLayer.m
//  PlantsAway
//
//  Created by Kara Yu on 4/22/12.
//  Copyright (c) 2012 Epic. All rights reserved.
//

#import "GameEndLayer.h"
#import "cocos2d.h"
#import "SceneManager.h"


@implementation GameEndLayer

@synthesize score, lives;

-(id)init
{
	//always call "super" init
	if((self=[super init])) 
    {
        //create a label to either congratulate or disparage the user depending on the score (default value is congratulate)
        gameEndLabel = [CCLabelTTF labelWithString:@"Congratulations!" dimensions:CGSizeMake(200, 300) alignment:UITextAlignmentCenter fontName:@"Marker Felt" fontSize:24 ];
        gameEndLabel.position = ccp( 160, 250 ); 
        [self addChild:gameEndLabel];
        
        //create and add label to tell user their score
        scoreLabel = [CCLabelTTF labelWithString: [NSString string] fontName:@"Marker Felt" fontSize:24 ];
        scoreLabel.position = ccp( 160, 100 );
        [self addChild:scoreLabel];
        
        //button to start new game
        CCMenuItemFont *startNew = [CCMenuItemFont itemFromString:@"New Game" target:self selector: @selector(newGame:)];
        
        //show menu with new game button
        CCMenu *menu = [CCMenu menuWithItems:startNew, nil];
        menu.position = ccp( 160, 50 );
        [menu alignItemsVerticallyWithPadding: 40.0f];
        [self addChild:menu z: 1];
    }
    return self;
}

//sets text to either congratulate or disparage the user depending on score
-(void)setScoreText 
{
    //lots of scenarios, depending on whether granny died from time or killing too many babies
    if (lives == 0 && self.score <50)
        [gameEndLabel setString: @"Sorry Granny, you killed too many babies.\n Plus,that was VERY disappointing! You could try again, but if I were you, I'd just give up"];
    else if (lives == 0 && self.score < 100)
        [gameEndLabel setString: @"Sorry Granny, you killed too many babies.\n Plus, pretty sure my 120 year old grandmother could do better.  Hope this teaches you to respect your elders"];
    else if (lives == 0 && self.score < 200)
    {
        gameEndLabel.position = ccp( 160, 200 ); 
        [gameEndLabel setString: @"Sorry Granny, you killed too many babies.\n BUT, that was aight"];
    }
    else if (lives == 0)
    {
        gameEndLabel.position = ccp( 160, 200 ); 
        [gameEndLabel setString: @"Sorry Granny, you killed too many babies.\n BUT, congratulations!!!"]; 
    }
    else if (self.score < 50)
        [gameEndLabel setString: @"That was VERY disappointing! You could try again, but if I were you, I'd just give up"];
    else if (self.score < 100) 
        [gameEndLabel setString: @"Pretty sure my 120 year old grandmother could do better.  Hope this teaches you to respect your elders"];
    else if (self.score < 200) 
    {
        gameEndLabel.position = ccp( 160, 200 ); 
        [gameEndLabel setString:@"That was aight"];
    }
    else 
    {
        gameEndLabel.position = ccp( 160, 200 ); 
        [gameEndLabel setString:@"Congratulations!"];
    } 
    //update score label with user's score
    [scoreLabel setString:[NSString stringWithFormat:@"Your score was %d", score]];
}

//called by new game button
- (void)newGame:(id)sender
{
	[SceneManager goInstructions];
}

@end


