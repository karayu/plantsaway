//
//  Sprites.m
//  PlantsAway
//
//  Created by Brooke Griffin on 4/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Sprite.h"

@implementation Sprite

@synthesize collision, start, speed, good;


-(id) init
{
    if( (self=[super init])) 
    {
        hoodlumTexture1=[[CCTexture2D alloc]initWithImage:[UIImage imageNamed:@"hoodlum.png"]];
        hoodlumTexture2=[[CCTexture2D alloc]initWithImage:[UIImage imageNamed:@"hoodlum2.png"]];
        momTexture1=[[CCTexture2D alloc]initWithImage:[UIImage imageNamed:@"mom.png"]];
        momTexture2=[[CCTexture2D alloc]initWithImage:[UIImage imageNamed:@"mom2.png"]];
        
    }
    
    return self;
}



//sets up sprite by initializing speed, left or right, whether it's a good sprite and gets collision to no
-(void) initializeSprite: (BOOL) type
{
    //initialize bools: currently no intersection of sprites
    self.collision = NO;
    self.good = type;
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
- (void) setTexture
{    
    if (self.good == YES)
    {
        if (self.start == 500)
        {
            self.texture = momTexture1;
        }
        else
        {
            self.texture = momTexture2;
        }
    }
    else {
        if (self.start == 500)
        {
            self.texture = hoodlumTexture1;
        }
        else
            self.texture = hoodlumTexture2;
    }
}



//determines random speed
-(void)initializeSpeed
{
    int randomNumber = arc4random() % 100;
    randomNumber += 10;
    self.speed = randomNumber;
}


//determines random left or right location
-(void)leftOrRight
{
    int randomNumber = arc4random() % 2;
    NSLog(@"rand num: %d", randomNumber);
    if (randomNumber == 1)
    {
        self.start = -12;
    }
    else {
        self.start = 500;

    }
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
