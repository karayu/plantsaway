//
//  Sprites.m
//  PlantsAway
//
//  Created by Brooke Griffin on 4/22/12.
//  Copyright (c) 2012 Epic. All rights reserved.
//

#import "Sprite.h"

@implementation Sprite

@synthesize level, collision, start, speed, good;


-(id) init
{
    if( (self=[super init])) 
    {
        //create textures for the hoodlum and mom depending on direction facing
        hoodlumTexture1=[[CCTexture2D alloc]initWithImage:[UIImage imageNamed:@"hoodlum.png"]];
        hoodlumTexture2=[[CCTexture2D alloc]initWithImage:[UIImage imageNamed:@"hoodlum2.png"]];
        momTexture1=[[CCTexture2D alloc]initWithImage:[UIImage imageNamed:@"mom.png"]];
        momTexture2=[[CCTexture2D alloc]initWithImage:[UIImage imageNamed:@"mom2.png"]];
    }
    
    return self;
}



//sets up sprite by initializing speed, left or right, whether it's a good sprite and gets collision to no
-(void) initializeSprite: (BOOL) type atLevel: (int) lev
{
    //initialize bools: currently no intersection of sprites
    self.collision = NO;
    self.good = type;
    self.level = lev;
    [self prepareTarget];
}

//prepares the target by setting speed, orientations and the right image.  called by initializeSprite
-(BOOL)prepareTarget
{
    [self initializeSpeed];
    [self leftOrRight];
    [self setTexture];
    [self updatePosition];

    if (self.start == 500)
    {
        self.speed = -self.speed;
        return YES;
    }
    return NO;
}

//sets the texture based on good or not and orientation
-(void)setTexture
{    
    //sets mom texture if good
    if (self.good == YES)
    {
        //texture now is based on orientation: left or right
        if (self.start == 500)
        {
            self.texture = momTexture1;
        }
        else
        {
            self.texture = momTexture2;
        }
    }
    //hoodlum texture if bad
    else 
    {
        //based on orientation: left/right
        if (self.start == 500)
        {
            self.texture = hoodlumTexture1;
        }
        else
        {
            self.texture = hoodlumTexture2;
        }
    }
}

//changes the direction of the sprite, used in higher levels
-(void)changeDirection
{
    self.speed = -self.speed;
    
    if (self.texture == momTexture1)
        self.texture = momTexture2;
    else if (self.texture == momTexture2) 
        self.texture = momTexture1;
    else if (self.texture == hoodlumTexture1)
        self.texture = hoodlumTexture2;
    else if (self.texture == hoodlumTexture2)
        self.texture = hoodlumTexture1;
}


//determines random speed
-(void)initializeSpeed
{
    int randomNumber = arc4random() % 100;
    
    randomNumber += 10*level;
    
    self.speed = randomNumber;
}


//determines random left or right location
-(void)leftOrRight
{
    int randomNumber = arc4random() % 2;

    //assign a start location depending on whether randomNumber is 1 or 0
    if (randomNumber == 1)
        self.start = -12;
    else
        self.start = 500;
}


//sets the position
-(void)updatePosition
{
    if (!self.position.y)
        self.position = ccp( self.start, 50 );
    
    self.position = ccp( self.start, self.position.y );
}


-(void)move: (ccTime) dt
{
    self.position = ccp( self.position.x + self.speed*dt, self.position.y );
}


-(BOOL)offScreen
{
    if((self.position.x > 480+32) || (self.position.x < -32))
        return YES;
    
    return NO;
}




@end
