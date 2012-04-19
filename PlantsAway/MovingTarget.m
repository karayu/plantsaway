//
//  MovingTarget.m
//  project3
//
//  Created by Kara Yu on 4/17/12.
//  Copyright (c) 2012 Epic. All rights reserved.
//

#import "MovingTarget.h"

@implementation MovingTarget

@synthesize goodOrBadGuy, velocity, startingPoint, endingPoint;


//define constants
int leftSidePosition = -50;
int rightSidePosition = 320;
int minVelocity = 15;


//sets values to bools
- (void)initProperties
{
    //random bool determines whether target will be good or bad
    self.goodOrBadGuy = arc4random() % 1;

    //random bool chooses whether target is starting on right (1) or left (0)
    int random = arc4random() % 1;
    
    //sets starting position as right or left, and then determines ending position based on the opposite of that
    if (random == 0)
    {
        self.startingPoint = leftSidePosition;
        self.endingPoint = rightSidePosition;
    }
    if (random == 1)
    {
        self.startingPoint = rightSidePosition;
        self.endingPoint = leftSidePosition;
    }
}


//return random velocity within reasonable limitations (in pixels per second)
-(void)initVelocity
{
    //return positive velocity for left starting position, negative for right starting position
    if (self.startingPoint == leftSidePosition)
    {
        //random number generated plus minimum value
        self.velocity = (arc4random() % 30) + minVelocity;
    }
    else if (self.startingPoint == rightSidePosition)
    {
        //negative value for starting point at rightSidePosition
        self.velocity = -((arc4random() % 30) + minVelocity);        
    }
    
    
    //manipulate velocity to be faster with more difficult levels
    //TO DO (FOR RELEASE)
}


@end
