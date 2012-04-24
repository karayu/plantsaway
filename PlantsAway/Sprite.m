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
        //initialize all the images we'll need
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
    //determine random speed
    [self initializeSpeed];
    
    //determine which side sprite starts on
    [self leftOrRight];
    
    //set image to match
    [self setTexture];
    
    //update sprite location
    [self updatePosition];

    //update speed to match orientation
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
            //image for mom starting from the right
            self.texture = momTexture1;
        }
        else
        {
            //image for mom starting from the left
            self.texture = momTexture2;
        }
    }
    else {
        if (self.start == 500)
        {
            //image for skateboarder starting from the right
            self.texture = hoodlumTexture1;
        }
        else
            //image for skateboarder starting from the left
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


//sets the position to match new start
-(void)updatePosition
{
    if (!self.position.y)
        self.position = ccp( self.start, 50 );
    
    self.position = ccp( self.start, self.position.y );
}

//moves the sprite using speed and change in time
-(void)move: (ccTime) dt
{
    self.position = ccp( self.position.x + self.speed*dt, self.position.y );
}

//determines whether sprite is off screen
-(BOOL)offScreen
{
    if((self.position.x > 480+32) || (self.position.x < -32))
        return YES;
    
    return NO;
}




@end
