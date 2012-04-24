//
//  MainLayer.h
//  PlantsAway
//
//  Created by Kara Yu on 4/17/12.
//  Copyright (c) 2012 Epic. All rights reserved.
//

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
    CCTexture2D *hoodlumTexture2;
    
    CCTexture2D *momTexture1;
    CCTexture2D *momTexture2;
}

//returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@property int score;
@property int time;

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

-(void)updateScore;
-(void)updateTime;




@end
