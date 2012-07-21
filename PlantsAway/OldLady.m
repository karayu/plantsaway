//
//  OldLady.m
//  project3
//
//  Created by Kara Yu on 4/17/12.
//  Copyright (c) 2012 Epic. All rights reserved.
//

#import "OldLady.h"

@implementation OldLady

@synthesize time, speed;

//set oldLady's constant speed
int initSpeed = 80.0;

-(id)init
{
    if (self = [super init])
    {
        //set up oldLady's two textures (normal & lifting plant)
        oldLadyTexture1=[[CCTexture2D alloc]initWithImage:[UIImage imageNamed:@"old1.png"]];
        oldLadyTexture2=[[CCTexture2D alloc]initWithImage:[UIImage imageNamed:@"old2.png"]];

        //initialize position and scale
        self.position = ccp( 160, 300 );
        [self setScale:0.5];
    }
    return self;
}

//sets the boost times the constant speed
-(void)setBoost:(int)boost
{
    speed = initSpeed*boost;
}


//calculates the updated position based on new position, old position, and velocity
- (ccTime)timeToPosition :(float)newPosition From:(float)oldPosition
{
    if (speed > 1000) 
        return 0;
    
    //determine which direction OldLady is moving in before making calculations 
    if (newPosition > oldPosition)
        return (newPosition - oldPosition)/speed;
    else 
        return (oldPosition - newPosition)/speed;
}

//sets the old lady image to one where she's lifting the plant
-(void) lift
{
    self.texture = oldLadyTexture2;
}

//restores old lady image back to normal
-(void) backToNormal
{
    self.texture = oldLadyTexture1;
}

@end
