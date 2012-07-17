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
#import "HighScores.h"

OldLady *oldLady;
CCSprite *plant;
CCSprite *hourGlass;
Sprite *goodTarget;
Sprite *badTarget;
HighScores *highScores;


int IncreScore = 10;
int IncreLevel = 40;

enum 
{
	kTagBatchNode = 1,
};

static void
eachShape(void *ptr, void* unused)
{
	cpShape *shape = (cpShape*) ptr;
	CCSprite *sprite = shape->data;
	if( sprite ) 
    {
		cpBody *body = shape->body;
		
		//chipmunk uses: cpVect, and cocos2d uses CGPoint but in reality the are the same
		[sprite setPosition: body->p];
		
		[sprite setRotation: (float) CC_RADIANS_TO_DEGREES( -body->a )];
	}
}

//MainLayer implementation
@implementation MainLayer

@synthesize lives, gameEnding, plantActive, startTouchPosition, endTouchPosition, score, time, level, boost, plantType, oldLadyMoving;


-(CCScene *)scene
{
	//initialize scene
	CCScene *scene = [CCScene node];
	
	//add layer as a child to scene
	[scene addChild: self];
	
	//return the scene
	return scene;
}


//on "init" you need to initialize your instance
-(id)init
{
	//always call "super" init
	if((self=[super init])) 
    {
        //initialize level
        level = 1; 
        
        //not in middle of gameEnding animation
        gameEnding = NO;
        
        //initialize the score
        score = 0;
        NSString *currentScore = [NSString stringWithFormat:@"%d pts", score];
        
        //number of times you can hit the baby before game ends
        lives = 1;
        
        //set up highscores table
        highScores = [[HighScores alloc] init];
        [highScores loadScores];
        
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
        time = 60; 
        
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
        [goodTarget initializeSprite:YES atLevel: level];
        [badTarget initializeSprite:NO atLevel: level];
        
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
        
        //schedulers for targets moving and plant resurrection
        [self schedule:@selector(nextFrameGoodTarget:)];		
        [self schedule:@selector(nextFrameBadTarget:)];	
        [self schedule:@selector(restorePlant:)];
        
        //scheduler for time countdown, and upleveling
        [self schedule: @selector(tick:) interval:1.0];
    }
	return self;
}

-(void)initBoost:(int)booster
{
    self.boost = booster;
    [oldLady setBoost: booster];
}

//set up plant at beginning of game play
-(void)setUpPlant:(int)plantNumber
{
    //declare plant type based on user's selection
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
    
    //add plant to layer
    plant.position = ccp( 160, 300 );
    [self addChild:plant];
    [plant setScale:0.5];
}

//Countdown timer. updates the time left and if you run out of time, ends game
-(void)tick:(ccTime)dt
{
    //if you've hit three babies, end the game
    if (lives == 0 )
    {
        //end game after doing animation of plant dropping on granny
        if ((plant.position.y - oldLady.position.y) < 30 && gameEnding == YES)
        {
            [self gameOver];
        }
        //do the animation of plant hitting granny
        else if (gameEnding == NO)
        {
            plant.position = ccp(oldLady.position.x, oldLady.position.y+150);
            
            //plant hits the top of granny
            id action = [CCMoveTo actionWithDuration:2 position: ccp(oldLady.position.x, oldLady.position.y + 20)]; 
            id ease = [CCEaseIn actionWithAction:action rate:2];
            [plant runAction: ease];

            gameEnding = YES;
        }
    }
    else 
    {
        time = time - dt/2;
        [timeLabel setString: [NSString stringWithFormat:@"%d", time]];
    
        //end game if reached end of your time
        if (time == 0) 
        {
            [self gameOver];
        }
        else if (score >= level*IncreLevel) 
        {           
            //alert the user that they've gone up a level with every IncreLevel points they score

            //source:http://www.cocos2d-iphone.org/forum/topic/1080
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: [NSString stringWithFormat:@"Congratulations! You've made it past level %d!", level]  message:@"Press the button to continue" delegate:self cancelButtonTitle:@"Resume" otherButtonTitles:nil];
            [alert show];
            [[CCDirector sharedDirector] pause];
        }
    }
}

//action after dismissing alert telling you that you've gone up a level. Increment level, reset time and decrease speed to make it harder for the next level
//http://www.cocos2d-iphone.org/forum/topic/1080
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex 
{    
    //increase user's level, reset time to 100, decrease speed
    level = level +1;
    time = 100;
    oldLady.speed = MAX(oldLady.speed - 20, 20);
    
    //resume game
	[[CCDirector sharedDirector] resume];
}

//listener for restoring the plant to the old lady. Tests whether plant has fallen to the end and the old lady has stopped moving.  Old lady can only get get plant back when she stops moving
-(void)restorePlant: (ccTime)dt
{
    
    //listen to see if old lady is moving. source: http://www.cocos2d-iphone.org/forum/topic/9211
    if ([oldLady numberOfRunningActions] > 0) 
    {
        CCAction *action = [oldLady getActionByTag:1];
        if (nil != action) 
        {
            if ([action isDone])
            {
                oldLadyMoving = NO;
            }
            //if the action is not complete, she is still in motion
            else if (![action isDone]) 
            {
                oldLadyMoving = YES;
            }
        }
    }
    else 
    {
        oldLadyMoving = NO;
    }
    
    //continue game play if we're not in middle of doing game end animation bc score is too low    
    if (!gameEnding)
    {
        //resurrect the plant if it's already fallen down all the way and the old lady isn't moving
        if (plant.position.y == -50 && !oldLadyMoving)
            plant.position = oldLady.position;
        
        //if plant gets resurrected in the wrong spot, fix it
        if (plant.position.y == oldLady.position.y)
            plant.position = oldLady.position;
    }
}

//Switches over the the GameEndLayer (passes the score). Called when player runs out of time
-(void)gameOver
{
    [highScores addHighScore:score];
    [SceneManager goEndGame: score lives: lives];
}

//Switches over the the GamePausedLayer (passes score and time). Called when player presses pause
-(void)pauseTapped
{
    [SceneManager goPause];
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
        else 
        {
            if (level > 5) {
                int i = arc4random() % 1000;
                
                if (i == 0)
                    [target changeDirection];
            }
            else if (level > 3) {
                int j = arc4random() % 500;
                
                if (j == 0)
                    [target changeDirection];
            }
            //if target has not yet been hit, continue to move normally across screen
            [target move: dt ];
        }
    }
}

//Calculates points of hit based on plant type and target type
-(void)calculateHit:(BOOL)good
{
    //we hit the good target(i.e. the mom), we decrement lives, otherwise, we increment points
    if (good)
        lives = lives - 1;
    else 
        score = score + (IncreScore*(4-plantType));
    
    
    [self updateScore];
}

//update the score label with current score
-(void)updateScore
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

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    //set location for oldLady to wherever touch ended
    CGPoint oldLadyLocation = [self convertTouchToNodeSpace: touch];
    oldLadyLocation.y = 300;
    
    //return oldLady to original view and show movement to touch location
    [oldLady backToNormal];
    
    ccTime travelDuration = [oldLady timeToPosition: (float)oldLadyLocation.x From: (float)oldLady.position.x];
    
    CCAction *ladyMoving = [CCMoveTo actionWithDuration:travelDuration position:oldLadyLocation];
    ladyMoving.tag = 1;
    [oldLady runAction:ladyMoving];
    
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
        [plant runAction: [CCMoveTo actionWithDuration:travelDuration position:oldLadyLocation]];
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
