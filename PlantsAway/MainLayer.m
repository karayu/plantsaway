//
//  MainLayer.m
//  PlantsAway
//
//  Created by Kara Yu on 4/17/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


//Import the interfaces
#import "MainLayer.h"
#import "CCTouchDispatcher.h"
#import "SceneManager.h"

CCSprite *oldLady;
CCSprite *plant;
CCSprite *hourGlass;
CCSprite *goodTarget;
CCSprite *badTarget;

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

@synthesize plantActive, swipedUp, startTouchPosition, endTouchPosition, goodCollision, badCollision, goodSpeed, badSpeed, goodStart, badStart, score, time;

+(CCScene *) scene
{
	//'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	//'layer' is an autorelease object.
	MainLayer *layer = [MainLayer node];
	
	//add layer as a child to scene
	[scene addChild: layer];
	
	//return the scene
	return scene;
}


//on "init" you need to initialize your instance
-(id) init
{
	//always call "super" init
	if( (self=[super init])) 
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
        timeLabel.position = ccp(50, 440 ); //Middle of the screen...
        [self addChild:timeLabel];
        [self schedule: @selector(tick:) interval:1.0];
        time = 100; 

        //initiate the background
        CCSprite *background = [CCSprite spriteWithFile: @"bg.png"];
        background.position = ccp(160, 187  ); //187
        [self addChild:background];
        [background setScale:0.24];
            
        //initiate images for all sprite positions
        oldLadyTexture1=[[CCTexture2D alloc]initWithImage:[UIImage imageNamed:@"old1.png"]];
        oldLadyTexture2=[[CCTexture2D alloc]initWithImage:[UIImage imageNamed:@"old2.png"]];
        hoodlumTexture1=[[CCTexture2D alloc]initWithImage:[UIImage imageNamed:@"hoodlum.png"]];
        hoodlumTexture2=[[CCTexture2D alloc]initWithImage:[UIImage imageNamed:@"hoodlum2.png"]];
        momTexture1=[[CCTexture2D alloc]initWithImage:[UIImage imageNamed:@"mom.png"]];
        momTexture2=[[CCTexture2D alloc]initWithImage:[UIImage imageNamed:@"mom2.png"]];
        
        //initiate oldLady
        oldLady = [CCSprite spriteWithTexture:oldLadyTexture1];
        oldLady.position = ccp( 160, 300 );
        [self addChild:oldLady];
        [oldLady setScale:0.5];
        
        //initiate her plant
        plant = [CCSprite spriteWithFile: @"flower.png"];
        plant.position = ccp( 160, 300 );
        [self addChild:plant];
        [plant setScale:0.5];

        //initialize good & bad target speed & position
        goodTarget = [CCSprite spriteWithTexture:momTexture1];
        badTarget = [CCSprite spriteWithTexture:hoodlumTexture1];

        [self prepareGoodTarget];
        [self prepareBadTarget];
        
        //initialize mommy and baby
        goodTarget.position = ccp( self.goodStart, 50 );
        [self addChild:goodTarget];
        [goodTarget setScale:0.75];
        
        //initialize hoodlum
        badTarget.position = ccp( self.badStart, 50 );
        [self addChild:badTarget];
        [badTarget setScale:0.75];
        
        //initialize bools: currently no intersection of sprites
        goodCollision = NO;
        badCollision = NO;
        
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


-(void) tick: (ccTime) dt
{
    time = time - dt/2;
    [timeLabel setString: [NSString stringWithFormat:@"%d", time]];
    
    if (time == 0) {
        [self gameOver];
    }
}

-(void) gameOver
{
    [SceneManager goEndGame: score];
}


- (void) pauseTapped
{
    [SceneManager goPause: score WithTime: time];
}

- (void) nextFrameGoodTarget:(ccTime)dt 
{
    //detect intersection of mom and plant
    if (CGRectIntersectsRect(goodTarget.boundingBox, plant.boundingBox))
    {
        //rotate to show that target was hit
        goodTarget.rotation = -90;
        
        //call this only once upon a collision (sets goodCollision to true upon the first hit)
        if (!goodCollision)
        {
            goodCollision = YES;
            [self calculateHit];
            
        }
    }
    else 
    {
        //if target has not yet been hit, continue to move normally across screen
        goodTarget.position = ccp( goodTarget.position.x + self.goodSpeed*dt, goodTarget.position.y );
        
        //if target was just hit or went offscreen, move to either left or right side and begin cycle again
        if (goodCollision || (goodTarget.position.x > 480+32) || (goodTarget.position.x < -32)) 
        {
            goodCollision = NO;
            goodTarget.rotation = 0;
            [self prepareGoodTarget];
            
            goodTarget.position = ccp( self.goodStart, goodTarget.position.y );

        }    
    }
}

- (void) nextFrameBadTarget:(ccTime)dt 
{
    //detect intersection of hoodlum and plant
    if (CGRectIntersectsRect(badTarget.boundingBox, plant.boundingBox))
    {
        //rotate to show that target was hit
        badTarget.rotation = 65;
        
        //call this only once upon a collision (sets badCollision to true upon first hit)
        if (!badCollision)
        {
            badCollision = YES;
            [self calculateHit];
            
        }
    }
    else 
    {
        //if target has not yet been hit, continue to move normally across screen
        badTarget.position = ccp( badTarget.position.x + self.badSpeed*dt, badTarget.position.y );
        
        //if target was just hit or went offscreen, move to either left or right side and begin cycle again
        if (badCollision || (badTarget.position.x > 480+32) || (badTarget.position.x < -32)) 
        {
            badCollision = NO;
            badTarget.rotation = 0;
            [self prepareBadTarget];
            
            badTarget.position = ccp( self.badStart, badTarget.position.y );
        }    
    }
}

//calculates points of hit
- (void) calculateHit
{
    if (goodCollision)
        score = score - 10;
    if (badCollision)
        score = score + 10;
        
    NSString *currentScore = [NSString stringWithFormat:@"%d pts", score];
    [scoreLabel setString:(NSString *)currentScore];
}

- (void) updateScore
{
    NSString *currentScore = [NSString stringWithFormat:@"%d pts", score];
    [scoreLabel setString:(NSString *)currentScore];
}

- (void) updateTime
{
    [timeLabel setString: [NSString stringWithFormat:@"%d", time]];
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

-(void)prepareGoodTarget
{
    self.goodSpeed = [self initializeSpeed];
    self.goodStart = [self leftOrRight];
    if (self.goodStart == 500)
    {
        self.goodSpeed = -self.goodSpeed;
        goodTarget.texture = momTexture1;
    }
    else
        goodTarget.texture = momTexture2;

}

-(void)prepareBadTarget
{
    self.badSpeed = [self initializeSpeed];
    self.badStart = [self leftOrRight];
    if (self.badStart == 500)
    {
        self.badSpeed = -self.badSpeed;
        badTarget.texture = hoodlumTexture1;
    }
    else
        badTarget.texture = hoodlumTexture2;

}

//initiates actions whenever user touches screen
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event 
{
    //when user touches screen, if plant has just been launched it returns to oldLady to prepare for RELAUNCH!
    if (plant.position.y < 0)
        plant.position = oldLady.position;
    
    //gets location of finger touch
    self.startTouchPosition = [self convertTouchToNodeSpace:touch];
    
    //if finger is touching plant, set plant to active
    if (CGRectContainsPoint(plant.boundingBox, self.startTouchPosition)) 
        self.plantActive = YES;
    
    return YES;
}


-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event 
{
    //only animate oldLady lift if plant is currently being pulled up or down
    if(self.plantActive) 
    {
        //while finger is still on screen, get new touch location
        self.endTouchPosition = [self convertTouchToNodeSpace: touch];
        
        //if endTouch is higher than startTouch, shows oldLady lifting plant above her head
        if (self.endTouchPosition.y > self.startTouchPosition.y)
        {            
            int newPlantY = oldLady.position.y + 30;
            CGPoint location = ccp(oldLady.position.x, newPlantY);
            plant.position = location;
            
            //change oldLady's texture to show her lifting the plant
            oldLady.texture = oldLadyTexture2;
            
            //sets swipedUp bool to true
            self.swipedUp = YES;
        }
    }
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    //set location for oldLady to wherever touch ended
    CGPoint oldLadyLocation = [self convertTouchToNodeSpace: touch];
    oldLadyLocation.y = 300;
    
    //return oldLady to original view and show movement to touch location
    //[oldLady stopAllActions]; //necessary?
    oldLady.texture = oldLadyTexture1;
    [oldLady runAction: [CCMoveTo actionWithDuration:2 position:oldLadyLocation]];
    
    //if plant was launched, its destination will be directly below oldLady's location
    CGPoint plantDestination = ccp( oldLadyLocation.x, -50 );
    
    //decide whether or not plant will stay with oldLady or be launched to the passersby!
    if (self.plantActive && self.swipedUp)
        [plant runAction: [CCMoveTo actionWithDuration:2 position:plantDestination]]; 
    else if (plant.position.y == oldLadyLocation.y)
        [plant runAction: [CCMoveTo actionWithDuration:2 position:oldLadyLocation]];
    
    //finger is no longer touching plant, finger is no longer swiping up
    self.plantActive = NO;
    self.swipedUp = NO;
}

//registers finger touch sensors
-(void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

@end
