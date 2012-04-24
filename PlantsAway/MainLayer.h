//
//  MainLayer.h
//  PlantsAway
//
//  Created by Kara Yu on 4/17/12.
//  Copyright (c) 2012 Epic. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"
#import "chipmunk.h"

//MainLayer for gameplay
@interface MainLayer : CCLayer
{
	cpSpace *space;
    CCLabelTTF *scoreLabel;
    CCLabelTTF *timeLabel;

    CCTexture2D *oldLadyTexture1;
    CCTexture2D *oldLadyTexture2;
    
    CCTexture2D *hoodlumTexture1;
    
    CCTexture2D *momTexture1;
}

//returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

//gameplay variables
@property int score;
@property int time;
@property BOOL plantActive;
@property BOOL swipedUp;

//gameplay methods
-(void)pauseTapped;
-(void)gameOver;
-(void)calculateHit:(BOOL)good;

//touch methods and properties
@property CGPoint startTouchPosition;
@property CGPoint endTouchPosition;
-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event;
-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event;
-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event;
-(void) registerWithTouchDispatcher;

//time methods
-(void)nextFrameBadTarget:(ccTime)dt;
-(void)nextFrameGoodTarget:(ccTime)dt; 
-(void)updateTime;
-(void)tick:(ccTime)dt;


@end
