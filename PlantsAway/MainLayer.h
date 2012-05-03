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

//returns a CCScene that contains the itself(MainLayer) as the only child
-(CCScene *) scene;

//global constants
extern int IncreScore;  //default amt to increment score when user scores
extern int IncreLevel;  //the score gap between different levels

//gameplay variables
@property int score;
@property int time;
@property int level;
@property BOOL plantActive; //whether user clicked on plant
@property BOOL oldLadyMoving; //whether the old lady is currently moving 

//@property (nonatomic, strong) CCAction *ladyMoving;

//the boost can be 1000 (infinite speed = teleportation), 2 (2x speed), or 1 (1x speed, no boost)
@property int boost;

//the plant can be 1 (tiny) 2(regular) or 3(big)
@property int plantType;

-(void) initBoost: (int)booster;

//gameplay methods
-(void)pauseTapped;
-(void)gameOver;
-(void)calculateHit:(BOOL)good;
-(void)setUpPlant:(int)plantNumber;

//touch methods and properties
@property CGPoint startTouchPosition;
@property CGPoint endTouchPosition;
-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event;
-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event;
-(void) registerWithTouchDispatcher;

//time methods
-(void)nextFrameBadTarget:(ccTime)dt;
-(void)nextFrameGoodTarget:(ccTime)dt; 
-(void)updateTime;
-(void)updateScore;
-(void)tick:(ccTime)dt;



@end
