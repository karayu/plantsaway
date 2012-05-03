//
//  GamePausedLayer.h
//  PlantsAway
//
//  Created by Kara Yu on 4/22/12.
//  Copyright (c) 2012 Epic. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"


//source: http://playsnackgames.com/blog/2011/09/cocos2d-tutorial-creating-a-reusable-pause-layer/
@interface PauseLayerProtocol: CCNode 
-(void)pauseLayerDidPause;
-(void)pauseLayerDidUnpause;
@end
    

@interface GamePausedLayer : CCLayer
{
    CCLabelTTF *gamePausedLabel;
    PauseLayerProtocol *delegate;

}

//returns a CCScene that contains the MainLayer as the only child
+(CCScene *) scene;

//variables to return to pause menu & eventually resume game
@property int score;
@property int time;
@property int boost;

//functionality to allow user to view other layers
-(void)newGame:(id)sender;
-(void)highScores:(id)sender;
-(void)resumeGame:(id)sender;

@end
