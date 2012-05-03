//
//  OldLady.h
//  project3
//
//  Created by Kara Yu on 4/17/12.
//  Copyright (c) 2012 Epic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "chipmunk.h"

@interface OldLady : CCSprite
{
    CCTexture2D *oldLadyTexture1;
    CCTexture2D *oldLadyTexture2;
}

//the properties that define OldLady's new location
@property float time;
@property float initSpeed;
@property float speed;


//constants (speed)
//extern int speed;

-(void) setBoost: (int) boost;
//returns time it takes for movement to new position
- (ccTime)timeToPosition :(float)newPosition From:(float)oldPosition;

-(void) lift;
-(void) backToNormal;




@end
