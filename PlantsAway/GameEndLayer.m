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

@synthesize score;

-(id) init
{
	//always call "super" init
	if( (self=[super init])) 
    {
        //Create and add the score label as a child.
        
        //create a label to either congratulate or disparage the user depending on the score (default value is congratulate)
        gameEndLabel = [CCLabelTTF labelWithString:@"Congratulations!" dimensions:CGSizeMake(200, 200) alignment:UITextAlignmentCenter fontName:@"Marker Felt" fontSize:24 ];
        gameEndLabel.position = ccp(160, 400 ); 
        [self addChild:gameEndLabel];
        
        //create and add label to tell user their score
        scoreLabel = [CCLabelTTF labelWithString: [NSString stringWithFormat:@"Your score was %d", score] fontName:@"Marker Felt" fontSize:24 ];
        scoreLabel.position = ccp(160, 150);
        [self addChild:scoreLabel];
      
        //button to start new game
        CCMenuItemFont *startNew = [CCMenuItemFont itemFromString:@"New Game" target:self selector: @selector(newGame:)];
        
        //show menu of new game button
        CCMenu *menu = [CCMenu menuWithItems:startNew, nil];
        menu.position = ccp(160, 50);
        [menu alignItemsVerticallyWithPadding: 40.0f];
        [self addChild:menu z: 1];

    }
    return self;
}

//sets text to either congratulate or disparage the user depending on score
- (void) setScoreText {
    if ( self.score < 50 )
    {
        [gameEndLabel setString: @"Well, that was VERY disappointing! You could try again, but if I were you, I'd just give up"];
        gameEndLabel.position = ccp(160, 300 ); 
    }
    else if (self.score <100) {
        [gameEndLabel setString:@"Pretty sure my 120 year old grandmother could do better.  Hope this teaches you to respect your elders"];
        gameEndLabel.position = ccp(160, 300 ); 

    }
    else if (self.score <200) {
        [gameEndLabel setString:@"That was aight"];
    }
    else {
        [gameEndLabel setString:@"Congratulations!"];
    }
    
    [scoreLabel setString:[NSString stringWithFormat:@"Your score was %d", score]];

}

//called by new score button
- (void)newGame:(id)sender{
	[SceneManager goNewGame];
}

@end


