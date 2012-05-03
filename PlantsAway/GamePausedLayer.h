//
//  GamePausedLayer.h
//  PlantsAway
//
//  Created by Kara Yu on 4/22/12.
//  Copyright (c) 2012 Epic. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"

//delegate for this layer
//source: http://playsnackgames.com/blog/2011/09/cocos2d-tutorial-creating-a-reusable-pause-layer/
@interface PauseLayerProtocol: CCNode 
-(void)pauseLayerDidPause;
-(void)pauseLayerDidUnpause;
@end

//set up pause layer interface
@interface GamePausedLayer : CCLayer
{
    CCLabelTTF *gamePausedLabel;
    PauseLayerProtocol *delegate;
}

//returns a CCScene that contains a GamePausedLayer as the only child
+(CCScene *) scene;

//functionality to allow user to view other layers (goes through SceneManager)
-(void)newGame:(id)sender;
-(void)highScores:(id)sender;
-(void)resumeGame:(id)sender;

@end
