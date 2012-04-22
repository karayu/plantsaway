//
//  HelloWorldLayer.h
//  PlantsAway
//
//  Created by Kara Yu on 4/17/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"


// Importing Chipmunk headers
#import "chipmunk.h"

// HelloWorldLayer
@interface MainLayer : CCLayer
{
	cpSpace *space;
    int score;    
    CCLabelTTF *scoreLabel;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
//-(void) step: (ccTime) dt;
//-(void) addNewSpriteX:(float)x y:(float)y;

@property BOOL plantActive;

@end
