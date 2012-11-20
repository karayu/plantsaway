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
    CCTexture2D *plantLightningTexture;
    CCTexture2D *sparkleBoostTexture;
}

//returns a CCScene that contains the itself(MainLayer) as the only child
-(CCScene *) scene;

//global constants
extern int IncreScore;  //default amt to increment score when user scores
extern int IncreLevel;  //the score gap between different levels
extern int DefaultDistance;  //the score gap between different levels

//gameplay variables
@property int plantSpeed;
@property int lives; 
@property int score;
@property int time;
@property int level;
@property BOOL gameEnding; //whether we're doing the ending animation because your score is too low
@property BOOL plantActive; //whether user clicked on plant
@property BOOL oldLadyMoving; //whether the old lady is currently moving 
@property int lightningboostOn; //time duration of lightning boost (0 when the boost isn't active)
@property int sparkleBoostOn; //time duration of sparkle boost (0 when the boost isn't active)
@property int boost; //the boost can be 1000 (teleportation), 2 (2x speed), or 1 (1x speed, no boost)
@property int plantType; //the plant can be 1 (tiny) 2(regular) or 3(big)
@property int plantBoost; //automatically set to zero, incremented to 2 (fast) or 3 (insane) if boost received

//gameplay methods
-(void)initBoost: (int)booster;
-(void)pauseTapped;
-(void)gameOver;
-(void)calculateHit:(BOOL)good;
-(void)setUpPlant:(int)plantNumber;

//touch methods and properties
@property CGPoint startTouchPosition;
@property CGPoint endTouchPosition;
-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event;
-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event;
-(void)registerWithTouchDispatcher;

//time methods
-(void)nextFrameBadTarget:(ccTime)dt;
-(void)nextFrameGoodTarget:(ccTime)dt; 
-(void)updateTime;
-(void)updateScore;
-(void)tick:(ccTime)dt;



@end
