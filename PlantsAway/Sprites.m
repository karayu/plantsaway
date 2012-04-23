//
//  Sprites.m
//  PlantsAway
//
//  Created by Brooke Griffin on 4/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Sprites.h"

@implementation Sprites

@synthesize score, goodCollision, badCollision, goodStart, badStart, goodSpeed, badSpeed;

-(void)initializeSprites
{
    
    //initialize bools: currently no intersection of sprites
    self.goodCollision = NO;
    self.badCollision = NO;
    
    [self prepareGoodTarget];
    [self prepareBadTarget];
}

-(BOOL)prepareGoodTarget
{
    self.goodSpeed = [self initializeSpeed];
    self.goodStart = [self leftOrRight];
    if (self.goodStart == 500)
    {
        self.goodSpeed = -self.goodSpeed;
        return YES;
    }
    return NO;
    
}

-(BOOL)prepareBadTarget
{
    self.badSpeed = [self initializeSpeed];
    self.badStart = [self leftOrRight];
    if (self.badStart == 500)
    {
        self.badSpeed = -self.badSpeed;
        return YES;
    }
    return NO;
    
}

//calculates points of hit
- (void)calculateHit
{
    if (self.goodCollision)
        self.score = self.score - 10;
    if (self.badCollision)
        self.score = self.score + 10;
}

//determines random speed
-(int)initializeSpeed
{
    int randomNumber = arc4random() % 100;
    randomNumber += 10;
    return randomNumber;
}

//determines random left or right location
-(int)leftOrRight
{
    int randomNumber = arc4random() % 2;
    NSLog(@"rand num: %d", randomNumber);
    if (randomNumber == 1)
        return -12;
    return 500;
}

@end
