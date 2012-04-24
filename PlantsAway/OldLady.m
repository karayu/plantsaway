//
//  OldLady.m
//  project3
//
//  Created by Kara Yu on 4/17/12.
//  Copyright (c) 2012 Epic. All rights reserved.
//

#import "OldLady.h"

@implementation OldLady

@synthesize time;

//define constants
int speed = 30;

-(id) init
{
    if (self = [super init])
    {
        oldLadyTexture1=[[CCTexture2D alloc]initWithImage:[UIImage imageNamed:@"old1.png"]];
        oldLadyTexture2=[[CCTexture2D alloc]initWithImage:[UIImage imageNamed:@"old2.png"]];

        self.position = ccp( 160, 300 );
        [self setScale:0.5];
    }
    
    return self;
}

//calculates the updated position based on new position, old position, and velocity
- (int)timeToPosition :(int)newPosition :(int)oldPosition
{
    //determine which direction OldLady is moving in before making calculations 
    if (newPosition > oldPosition)
        return (newPosition - oldPosition)/speed;
    else 
        return (oldPosition - newPosition)/speed;
}

-(void) lift
{
    self.texture = oldLadyTexture2;
}

-(void) backToNormal
{
    self.texture = oldLadyTexture1;
}

@end
