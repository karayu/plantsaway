//
//  MainLayer.m
//  PlantsAway
//
//  Created by Kara Yu on 4/17/12.
//  Copyright (c) 2012 Epic. All rights reserved.
//

#import "MainLayer.h"
#import "CCTouchDispatcher.h"
#import "SceneManager.h"
#import "Sprite.h"
#import "OldLady.h"
#import "InstructionsLayer.h"

OldLady *oldLady;
CCSprite *plant;
CCSprite *hourGlass;
Sprite *goodTarget;
Sprite *badTarget;

enum 
{
	kTagBatchNode = 1,
};

static void
eachShape(void *ptr, void* unused)
{
	cpShape *shape = (cpShape*) ptr;
	CCSprite *sprite = shape->data;
	if( sprite ) {
		cpBody *body = shape->body;
		
		//TIP: cocos2d and chipmunk uses the same struct to store its position
		//chipmunk uses: cpVect, and cocos2d uses CGPoint but in reality the are the same
		//since v0.7.1 you can mix them if you want.		
		[sprite setPosition: body->p];
		
		[sprite setRotation: (float) CC_RADIANS_TO_DEGREES( -body->a )];
	}
}

//MainLayer implementation
@implementation MainLayer

@synthesize plantActive, startTouchPosition, endTouchPosition, score, time, boost, plantType;

+(CCScene *) scene
{
	//initialize scene
	CCScene *scene = [CCScene node];
	
	//initialize layer
	//MainLayer *layer = [MainLayer node];
    InstructionsLayer *layer =  [InstructionsLayer node];
    
	//add layer as a child to scene
	[scene addChild: layer];
	
	//return the scene
	return scene;
}


//on "init" you need to initialize your instance
-(id)init
{
	//always call "super" init
	if((self=[super init])) 
    {
        //initialize the score
        score = 0;
        NSString *currentScore = [NSString stringWithFormat:@"%d pts", score];
        
        //Create and add the score label as a child.
        scoreLabel = [CCLabelTTF labelWithString:currentScore fontName:@"Marker Felt" fontSize:24];
        scoreLabel.position = ccp(160, 440 ); 
        [self addChild:scoreLabel];
        
        //Create and add pause button as a child
        CCMenuItem *pauseMenuItem = [CCMenuItemImage 
                                     itemFromNormalImage: @"pause.png" selectedImage:@"pause.png" 
                                     target:self selector:@selector(pauseTapped)];
        pauseMenuItem.position = ccp(350, 530);
        CCMenu *pauseMenu = [CCMenu menuWithItems:pauseMenuItem, nil];
        pauseMenu.position = CGPointZero;
        [self addChild:pauseMenu];
        [pauseMenu setScale:0.7];
        
        //create and add hour glass
        hourGlass = [CCSprite spriteWithFile: @"hourglass.jpg"];
        hourGlass.position = ccp( 20, 440 );
        [self addChild:hourGlass];
        [hourGlass setScale:0.12];
        
        //count down timer for gameplay
        timeLabel = [CCLabelTTF labelWithString:@"100" fontName:@"Marker Felt" fontSize:24];
        timeLabel.position = ccp( 50, 440 ); //Middle of the screen...
        [self addChild:timeLabel];
        [self schedule: @selector(tick:) interval:1.0];
        time = 100; 
        
        //initiate the background
        CCSprite *background = [CCSprite spriteWithFile: @"bg.png"];
        background.position = ccp( 160, 187 );
        [self addChild:background];
        [background setScale:0.24];

        //initiate image for old lady
        oldLadyTexture1=[[CCTexture2D alloc]initWithImage:[UIImage imageNamed:@"old1.png"]];
        
        //initial images for the targets
        hoodlumTexture1=[[CCTexture2D alloc]initWithImage:[UIImage imageNamed:@"hoodlum.png"]];
        momTexture1=[[CCTexture2D alloc]initWithImage:[UIImage imageNamed:@"mom.png"]];
        
        //initiate oldLady
        oldLady = [OldLady spriteWithTexture:oldLadyTexture1];
        [OldLady initialize];
        [self addChild:oldLady];
        
        //create targets
        goodTarget = [Sprite spriteWithTexture:momTexture1];
        badTarget = [Sprite spriteWithTexture:hoodlumTexture1];
        
        //initializes targets with orientations, speed, good or not
        [goodTarget initializeSprite:YES];
        [badTarget initializeSprite:NO];
        
        //add mommy and baby
        [self addChild:goodTarget];
        [goodTarget setScale:0.75];
        
        //add hoodlum
        [self addChild:badTarget];
        [badTarget setScale:0.75];
        
        //our finger is not currrently on the plant
        self.plantActive = NO;  
        
        //make touch enabled
		self.isTouchEnabled = YES;
        
		cpInitChipmunk();
        
        [self schedule:@selector(nextFrameGoodTarget:)];		
        [self schedule:@selector(nextFrameBadTarget:)];	
    }
	return self;
}

//set plant
-(void)setUpPlant:(int)plantNumber
{
    self.plantType = plantNumber;

    //initiate her plant based on selecte plantType on initial screen (InstructionsLayer)
    switch (plantType)
    {
        case 1:
            plant = [CCSprite spriteWithFile: @"leaf.png"];
            break;
        case 2:
            plant = [CCSprite spriteWithFile: @"flower.png"];
            break;
        case 3:
            plant = [CCSprite spriteWithFile: @"shrub.png"];
            break;
    }
    plant.position = ccp( 160, 300 );
    [self addChild:plant];
    [plant setScale:0.5];
}

//Countdown timer. updates the time left and if you run out of time, ends game
-(void)tick:(ccTime)dt
{
    time = time - dt/2;
    [timeLabel setString: [NSString stringWithFormat:@"%d", time]];
    
    //end game if reached end of your time
    if (time == 0) 
    {
        [self gameOver];
    }
}

//Switches over the the GameEndLayer (passes the score). Called when player runs out of time
-(void)gameOver
{
    [SceneManager goEndGame: score];
}

//Switches over the the GamePausedLayer (passes score and time). Called when player presses pause
-(void)pauseTapped
{
    [SceneManager goPause: score WithBoost: boost WithTime: time];
}

//Thread for good target. Mom + baby either move along or gets hit by granny
-(void)nextFrameGoodTarget:(ccTime)dt 
{
    [self moveOrDie:goodTarget InTime:dt];
}

//Thread for bad target. Skateboarder either move along or gets hit by granny
-(void)nextFrameBadTarget:(ccTime)dt 
{
    [self moveOrDie:badTarget InTime:dt];
}

//function for target to either keep moving (if they haven't been hit) or die if they have been hit
-(void)moveOrDie:(Sprite *)target InTime:(ccTime)dt
{
    //detect intersection of hoodlum and plant
    if (CGRectIntersectsRect(target.boundingBox, plant.boundingBox))
    {
        //rotate to show that target was hit
        target.rotation = 65;
        
        //call this only once upon a collision (sets badCollision to true upon first hit)
        if (!target.collision)
        {
            target.collision = YES;
            [self calculateHit: target.good];
            
        }
    }
    else 
    {
        //if target was just hit or went offscreen, move to either left or right side and begin cycle again
        if (target.collision || [target offScreen]) 
        {
            target.collision = NO;
            target.rotation = 0;
            
            //creates new target orientation, position, speed, etc
            [target prepareTarget];
            
        }
        else {
            //if target has not yet been hit, continue to move normally across screen
            [target move: dt ];
        }
    }
}


//Calculates points of hit and updates the score. Passes in whether the target hit was a good target or not
-(void)calculateHit:(BOOL)good
{
    //we hit the good target(i.e. the mom), we subtract points, otherwise, we increment
    if (good)
        score = score - 10;
    else 
        score = score + 10;
    
    [self updateScore];
}

//update the score label with current score
-(void) updateScore
{
    NSString *currentScore = [NSString stringWithFormat:@"%d pts", score];
    [scoreLabel setString:(NSString *)currentScore];
}

//updates the time label
-(void)updateTime
{
    [timeLabel setString: [NSString stringWithFormat:@"%d", time]];
}


#pragma mark touch methods

//initiates actions whenever user touches screen
-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event 
{
    //when user touches screen, if plant has just been launched it returns to oldLady to prepare for RELAUNCH!
    if (plant.position.y == -50)
        plant.position = oldLady.position;
    
    //gets location of finger touch
    self.startTouchPosition = [self convertTouchToNodeSpace:touch];
    
    //if finger is touching plant, set plant to active
    if (CGRectContainsPoint(plant.boundingBox, self.startTouchPosition)) 
    {
        //plant is NOW ACTIVE!
        self.plantActive = YES;
        
        //reposition plant
        int newPlantY = oldLady.position.y + 30;
        CGPoint location = ccp(oldLady.position.x, newPlantY);
        plant.position = location;
        
        //change oldLady's texture to show her lifting the plant
        [oldLady lift]; 
    }
        
    return YES;
}

/*
-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event 
{
    //only animate oldLady lift if plant is currently being pulled up or down
    if(self.plantActive) 
    {
        //reposition plant
        int newPlantY = oldLady.position.y + 30;
        CGPoint location = ccp(oldLady.position.x, newPlantY);
        plant.position = location;
        
        //change oldLady's texture to show her lifting the plant
        [oldLady lift];

    }
}
*/

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    //set location for oldLady to wherever touch ended
    CGPoint oldLadyLocation = [self convertTouchToNodeSpace: touch];
    oldLadyLocation.y = 300;
    
    //return oldLady to original view and show movement to touch location
    [oldLady backToNormal];
    [oldLady runAction: [CCMoveTo actionWithDuration:self.boost position:oldLadyLocation]];
    
    //if plant was launched, its destination will be directly below oldLady's location
    CGPoint plantDestination = ccp( oldLadyLocation.x, -50 );
    
    //decide whether or not plant will stay with oldLady or be launched to the passersby!
    if (self.plantActive && plant.position.y >= oldLadyLocation.y)
    {
        id action = [CCMoveTo actionWithDuration:2 position:plantDestination]; 
        id ease = [CCEaseIn actionWithAction:action rate:2];
        [plant runAction: ease];
    }
    else if (plant.position.y == oldLadyLocation.y)
    {
        [plant runAction: [CCMoveTo actionWithDuration:self.boost position:oldLadyLocation]];
    }
    
    //finger is no longer touching plant
    self.plantActive = NO;
}

//registers finger touch sensors
-(void)registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

@end
