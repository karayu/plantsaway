//
//  HelloWorldLayer.h
//  PlantsAway
//
//  Created by Kara Yu on 4/17/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


//When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

//Importing Chipmunk headers
#import "chipmunk.h"

//MainLayer for gameplay
@interface MainLayer : CCLayer
{
	cpSpace *space;
    int score;
    int time;
    CCLabelTTF *scoreLabel;
    CCLabelTTF *timeLabel;

    CCTexture2D *oldLadyTexture1;
    CCTexture2D *oldLadyTexture2;
    
    CCTexture2D *hoodlumTexture1;
    CCTexture2D *hoodlumTexture2;
    
    CCTexture2D *momTexture1;
    CCTexture2D *momTexture2;
}

//returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

//-(void) step: (ccTime) dt;
//-(void) addNewSpriteX:(float)x y:(float)y;

@property BOOL plantActive;
@property BOOL swipedUp;
@property BOOL goodCollision;
@property BOOL badCollision;
@property int goodSpeed;
@property int badSpeed;
@property int goodStart;
@property int badStart;

@property CGPoint startTouchPosition;
@property CGPoint endTouchPosition;


@end
