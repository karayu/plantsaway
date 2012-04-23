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

@synthesize plantActive, swipedUp, startTouchPosition, endTouchPosition, goodCollision, badCollision;

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
		
        //initiate the menu

        score = 0;
        
        //Create and add the score label as a child.
        scoreLabel = [CCLabelTTF labelWithString:@"0 pts" fontName:@"Marker Felt" fontSize:24];
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
            
        //initiate images for oldLady's two positions
        oldLadyTexture1=[[CCTexture2D alloc]initWithImage:[UIImage imageNamed:@"old1.png"]];
        oldLadyTexture2=[[CCTexture2D alloc]initWithImage:[UIImage imageNamed:@"old2.png"]];
        
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

        //initialize mommy and baby
        goodTarget = [CCSprite spriteWithFile: @"mom2.png"];
        goodTarget.position = ccp( 0, 50 );
        [self addChild:goodTarget];
        [goodTarget setScale:0.75];
        
        //initialize hoodlum
        badTarget = [CCSprite spriteWithFile: @"hoodlum.png"];
        badTarget.position = ccp( 500, 50 );
        [self addChild:badTarget];
        [badTarget setScale:0.75];
        
        //initialize bools: currently no intersection of sprites
        goodCollision = NO;
        badCollision = NO;
        
        //our finger is not currrently on the plant
        self.plantActive = NO;  
        
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
		

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

//on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	//in case you have something to dealloc, do it in this method
	cpSpaceFree(space);
	space = NULL;
	
	//don't forget to call "super dealloc"
	[super dealloc];
}

- (void) pauseTapped
{
    [SceneManager goPause];
}

-(void) onEnter
{
	[super onEnter];
	
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / 60)];
}

- (void) nextFrameGoodTarget:(ccTime)dt 
{
    //detect intersection of mom and plant
    if (CGRectIntersectsRect(goodTarget.boundingBox, plant.boundingBox))
    {
        //rotate to show that target was hit
        goodTarget.rotation = -90;
        
        //set collision bool to true
        goodCollision = YES;
    }
    else 
    {
        //if target has not yet been hit, continue to move normally across screen
        goodTarget.position = ccp( goodTarget.position.x + 20*dt, goodTarget.position.y );
        
        //if target was just hit or went offscreen, move to either left or right side and begin cycle again
        if (goodCollision || goodTarget.position.x > 480+32) 
        {
            goodCollision = NO;
            goodTarget.rotation = 0;
            goodTarget.position = ccp( -32, goodTarget.position.y );
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
        
        //set collision bool to true
        badCollision = YES;
    }
    else 
    {
        //if target has not yet been hit, continue to move normally across screen
        badTarget.position = ccp( badTarget.position.x - 20*dt, badTarget.position.y );
        
        //if target was just hit or went offscreen, move to either left or right side and begin cycle again
        if (badCollision || badTarget.position.x < -32) 
        {
            badCollision = NO;
            badTarget.rotation = 0;
            badTarget.position = ccp( 480+32, badTarget.position.y );
        }    
    }
}

//calculates points of hit


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

//senses whether or not phone is moved/tilted/etc
- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{	
	static float prevX=0, prevY=0;
	
    #define kFilterFactor 0.05f
	
	float accelX = (float) acceleration.x * kFilterFactor + (1- kFilterFactor)*prevX;
	float accelY = (float) acceleration.y * kFilterFactor + (1- kFilterFactor)*prevY;
	
	prevX = accelX;
	prevY = accelY;
	
	CGPoint v = ccp( accelX, accelY);
	
	space->gravity = ccpMult(v, 200);
}
@end
